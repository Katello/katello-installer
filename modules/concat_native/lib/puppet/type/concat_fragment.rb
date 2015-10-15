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
Puppet::Type.newtype(:concat_fragment) do
  @doc = "Create a concat fragment. If you do not create an associated
          concat_build object, then one will be created for you and the
          defaults will be used."

  newparam(:name) do
    isnamevar
    validate do |value|
      fail Puppet::Error, "name is missing group or name. Name format must be 'group+fragment_name'" if value !~ /.+\+.+/
      fail Puppet::Error, "name cannot include '../'!" if value =~ /\.\.\//
    end
  end

  newparam(:frag_group) do
    desc "Ignore me, I'm a convienience stub"
    defaultto 'fake'

    munge do |value|
      @resource[:name].split('+').first
    end
  end

  newparam(:frag_name) do
    desc "Ignore me, I'm a convienience stub"
    defaultto 'fake'

    munge do |value|
      @resource[:name].split('+')[1..-1].join('+')
    end
  end

  newproperty(:content) do

    def retrieve

    !@frags_to_delete and @frags_to_delete = []
      return provider.retrieve
    end

    def insync?(is)
      is and @should or return false

      # @should is an Array through Puppet magic.
      is.strip == @should.first.strip
    end

    def sync
      provider.create
    end

  end

  # This is only here because, at this point, we can be sure that the catalog
  # has been compiled. This checks to see if we have a concat_build specified
  # for our particular concat_fragment group.
  autorequire(:file) do
    if not catalog.resource("Concat_build[#{self[:frag_group]}]") then
      err "No 'concat_build' specified for group '#{self[:frag_group]}'"
    end
    ""
  end

  validate do
    fail Puppet::Error, "You must specify content" unless self[:content]
  end

  def create_default_build
    # If the user did not specify a concat_build object in their manifest,
    # assume that they want the defaults and create one for them.
    if not @catalog.resource("Concat_build[#{self[:frag_group]}]") then
      debug "Auto-adding 'concat_build' resource Concat_build['#{self[:frag_group]}'] to the catalog"
      @catalog.add_resource(Puppet::Type.type(:concat_build).new(
        :name => "#{self[:frag_group]}"
      ))
    end
  end

  def purge_unknown_fragments
    # Kill all unmanaged fragments for this group
    known_resources = []

    # Find everything that we shouldn't delete.
    catalog.resources.find_all { |r|
      (r.is_a?(Puppet::Type.type(:concat_fragment)) and r[:frag_group] == self[:frag_group] ) or
      (r.is_a?(Puppet::Type.type(:concat_build)) and r[:target] and File.dirname(r[:target]) == "#{Puppet[:vardir]}/concat_native/fragments/#{self[:frag_group]}")
    }.each do |frag_res|
      if frag_res.is_a?(Puppet::Type.type(:concat_fragment)) then
        known_resources << "#{Puppet[:vardir]}/concat_native/fragments/#{frag_res[:frag_group]}/#{frag_res[:frag_name]}"
      elsif frag_res.is_a?(Puppet::Type.type(:concat_build)) then
        known_resources << frag_res[:target]
      else
        debug "Woops, found an unknown fragment of type #{frag_res.class}"
      end
    end

    (Dir.glob("#{Puppet[:vardir]}/concat_native/fragments/#{self[:frag_group]}/*") - known_resources).each do |to_del|
      debug "Deleting Unused Fragment: #{to_del}"
      FileUtils.rm(to_del)
    end
  end

  def finish
    create_default_build
    purge_unknown_fragments
    super
  end
end
