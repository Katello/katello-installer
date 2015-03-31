#
# Copyright (C) 2012 Onyx Point, Inc. <http://onyxpoint.com/>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
Puppet::Type.newtype(:concat_build) do
  @doc = "Build file from fragments"

  def extractexe(cmd)
    # easy case: command was quoted
    if cmd =~ /^"([^"]+)"/
      $1
    else
      cmd.split(/ /)[0]
    end
  end

  def validatecmd(cmd)
    exe = extractexe(cmd)
    fail Puppet::Error, "'#{cmd}' is unqualifed" if File.expand_path(exe) != exe
  end

  newparam(:clean_comments) do
    desc "If a line begins with the specified string it will not be printed in the output file."
  end

  newparam(:clean_whitespace) do
    desc "Cleans whitespace.  Can be passed an array.  'lines' will cause the 
          output to not contain any blank lines. 'all' is equivalent to 
          [leading, trailing, lines]"
    munge do |value|
      [value].flatten!
      if value.include?('all') then
        return ['leading', 'trailing', 'lines']
      end
      [value].flatten.uniq
    end

    validate do |value|
      [value].flatten!
      if value.include?('none') and value.uniq.length > 1 then
        fail Puppet::Error, "You cannot specify 'none' with any other options"
      end
    end

    newvalues(:leading, :trailing, :lines, :all, :none)
    defaultto [:none]
  end

  newparam(:file_delimiter) do
    desc "Acts as the delimiter between concatenated file fragments. For
          instance, if you have two files with contents 'foo' and 'bar', the
          result with a file_delimiter of ':' will be a file containing
          'foo:bar'."
    defaultto ""
  end

  newparam(:append_newline, :boolean => true) do
    desc "Whether or not to automatically append a newline to the file
          delimiter.  For example, with no file_delimiter and
          'append_newline => false' the fragments will all wind up on the same
          line."
    newvalues(:true, :false)
    defaultto :true
  end

  newparam(:name) do
    isnamevar
    validate do |value|
      fail Puppet::Error, "concat_name cannot include '../'!" if value =~ /\.\.\//
    end
  end

  newparam(:onlyif) do
    desc "Copy file to target only if this command exits with status '0'"
    validate do |cmds|
      [cmds].flatten! 

      cmds.each do |cmd|
        @resource.validatecmd(cmd)
      end
    end

    munge do |cmds|
      [cmds].flatten
    end
  end

  newparam(:sort, :boolean => true) do
    desc "Sort the built file. This tries to sort in a human fashion with 
          1 < 2 < 10 < 20 < a, etc..  sort. Note that this will need to read
          the entire file into memory

          Example Sort:

          ['a','1','b','10','2','20','Z','A']

          translates to

          ['1','2','10','20','a','A','b','Z']

          Note: If you use a file delimiter with this, it *will not* be sorted!"
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:squeeze_blank, :boolean => true) do
    desc "Never output more than one blank line"
    newvalues(:true, :false)
    defaultto :false
  end

  newproperty(:target) do
    desc "Fully qualified path to copy output file to"
    defaultto 'unknown'

    validate do |path|
      unless path == 'unknown' or path =~ /^\/$/ or path =~ /^\/[^\/]/
        fail Puppet::Error, "File paths must be fully qualified, not '#{path}'"
      end
    end

    munge do |value|
      if value == 'unknown' then
        value = "#{Puppet[:vardir]}/concat_native/output/#{resource[:name]}.out"
      end
      value
    end

    def retrieve
      if File.exist?(@resource[:target]) then
        return @resource[:target]
      end

      return nil
    end

    def insync?(is)
      return provider.insync?(is,provider.build_file)
    end

    def sync
      provider.sync
    end

    def change_to_s(currentvalue, newvalue)
      "#{@resource[:order]} used for ordering"
    end
  end

  newparam(:parent_build) do
    desc "Specify the parent to this build step. Only needed for multiple
          staged builds. Can be an array."
  end

  newparam(:quiet, :boolean => true) do
    desc "Suppress errors when no fragments exist for build"
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:unique) do
    desc "Only print unique lines to the output file. Sort takes precedence.
          This does not affect file delimiters.

          true: Uses Ruby's Array.uniq function. It will remove all duplicates
          regardless  of where they are in the file.
 
          uniq: Acts like the uniq command found in GNU coreutils and only
          removes consecutive duplicates."

    newvalues(:true, :false, :uniq)
    defaultto :false
  end

  newparam(:order, :array_matching => :all) do
    desc "Array containing ordering info for build"

    defaultto ["*"]
  end

  autorequire(:concat_build) do
    req = []
    # resource contains all concat_build resources from the catalog that are
    # children of this concat_build
    resource = catalog.resources.find_all { |r| r.is_a?(Puppet::Type.type(:concat_build)) and r[:parent_build] and Array(r[:parent_build]).flatten.include?(self[:name]) }
    if not resource.empty? then
      req << resource
    end
    req.flatten!
    req.each { |r| debug "Autorequiring #{r}" }
    req
  end

  autorequire(:concat_fragment) do
    req = []
    # resource contains all concat_fragment resources from the catalog that
    # belog to this concat_build
    resource = catalog.resources.find_all { |r| r.is_a?(Puppet::Type.type(:concat_fragment)) and r[:name] =~ /^#{self[:name]}\+.+/ }
    if not resource.empty? then
      req << resource
    elsif not self.quiet? then
      err "No fragments specified for group #{self[:name]}!"
    end
    # clean up the fragments directory for this build if there are no fragments
    # in the catalog
    if resource.empty? and File.directory?("#{Puppet[:vardir]}/concat_native/fragments/#{self[:name]}") then
      FileUtils.rm_rf("#{Puppet[:vardir]}/concat_native/fragments/#{self[:name]}")
    end
    if self[:parent_build] then
      found_parent = false
      Array(self[:parent_build]).flatten.each do |parent_build|
        # Checks to see if there is a concat_build for each parent_build specified
        if catalog.resource("Concat_build[#{parent_build}]") then
          found_parent = true
        elsif not self.quiet? then
          warning "No concat_build found for parent_build #{parent_build}"
        end
        # frags contains all concat_fragment resources for the parent concat_build
        frags = catalog.resources.find_all { |r| r.is_a?(Puppet::Type.type(:concat_fragment)) and r[:name] =~ /^#{parent_build}\+.+/ }
        if not frags.empty? then
          req << frags
        end
      end
      if not found_parent then
        err "No concat_build found for any of #{Array(self[:parent_build]).flatten.join(",")}"
      end
    end
    req.flatten!
    req.each { |r| debug "Autorequiring #{r}" }
    req
  end

end
