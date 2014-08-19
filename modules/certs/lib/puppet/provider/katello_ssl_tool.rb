require 'fileutils'
module Puppet::Provider::KatelloSslTool

  class Cert < Puppet::Provider

    initvars

    commands :rpm => 'rpm'
    commands :yum => 'yum'
    commands :katello_ssl_tool_command => 'katello-ssl-tool'

    def exists?
      ! generate? && ! deploy?
    end

    def create
      generate! if generate?
      deploy!   if deploy?
    end

    def self.details(cert_name)
      details = { :pubkey  => pubkey(cert_name),
                  :privkey   => privkey(cert_name) }

      return details
    end

    def self.pubkey(name)
      target_path("certs/#{name}.crt")
    end

    def self.privkey(name)
      target_path("private/#{name}.key")
    end

    protected

    def katello_ssl_tool(*args)
      Dir.chdir('/root') do
        katello_ssl_tool_command(*args)
      end
    end

    def generate!
      if File.exists?(update_file)
        File.delete(update_file)
      end
    end

    def generate?
      return false unless resource[:generate]
      return true if resource[:regenerate]
      return true if File.exists?(update_file)
      return files_to_generate.any? { |file| ! File.exist?(file) }
    end

    def files_to_generate
      [rpmfile]
    end

    def deploy?
      return false unless resource[:deploy]
      return true if resource[:regenerate]
      return true if files_to_deploy.any? { |file| ! File.exist?(file) }
      return true if new_version_available?
    end

    def files_to_deploy
      [pubkey, privkey]
    end

    def deploy!
      if File.exists?(rpmfile)
        # the rpm is available locally on the file system
        rpm('-Uvh', '--force', rpmfile)
      else
        # we search the rpm in yum repo
        yum("install", "-y", rpmfile_base_name)
      end
    end

    def new_version_available?
      if File.exists?(rpmfile)
        current_version = version_from_name(`rpm -q #{rpmfile_base_name}`)
        latest_version = version_from_name(`rpm -pq #{rpmfile}`)
        (latest_version <=> current_version) > 0
      else
        `yum check-update #{rpmfile_base_name} &>/dev/null`
        $?.exitstatus == 100
      end
    end

    def version_from_name(rpmname)
      rpmname.scan(/\d+/).map(&:to_i)
    end

    def common_args
      [ '--set-country', resource[:country],
       '--set-state', resource[:state],
       '--set-city', resource[:city],
       '--set-org', resource[:org],
       '--set-org-unit', resource[:org_unit],
       '--set-email', resource[:email],
       '--cert-expiration', resource[:expiration]]
    end

    def rpmfile
      rpmfile = Dir[self.build_path("#{rpmfile_base_name}*.noarch.rpm")].max_by do |file|
        version_from_name(file)
      end
      rpmfile ||= self.build_path("#{rpmfile_base_name}.noarch.rpm")
      return rpmfile
    end

    # file that indicates that a new version of the rpm should be updated
    def update_file
      self.build_path("#{rpmfile_base_name}.update")
    end

    def rpmfile_base_name
      resource[:name]
    end

    def pubkey
      self.class.pubkey(resource[:name])
    end

    def privkey
      self.class.privkey(resource[:name])
    end

    def full_path(file_name)
      self.class.full_path(file_name)
    end

    def target_path(file_name = '')
      self.class.target_path(file_name)
    end

    def self.target_path(file_name = '')
      File.join("/etc/pki/katello-certs-tools", file_name)
    end

    def build_path(file_name = '')
      self.class.build_path(file_name)
    end

    def self.build_path(file_name = '')
      File.join("/root/ssl-build", file_name)
    end

    def ca_details
      return @ca_details if defined? @ca_details
      if ca_resource = @resource[:ca]
        name = ca_resource.to_hash[:name]
        @ca_details = Puppet::Provider::KatelloSslTool::Cert.details(name)
      else
        raise 'Wanted to generate cert without ca specified'
      end
    end
  end

  class CertFile < Puppet::Provider

    include Puppet::Util::Checksums

    initvars

    commands :openssl => 'openssl'

    def exists?
      return false unless File.exists?(resource[:path])
      checksum(expected_content) == checksum(current_content)
    end

    def create
      File.open(resource[:path], "w", mode) { |f| f << expected_content }
    end

    protected

    def expected_content
      File.read(source_path)
    end

    def current_content
      File.read(resource[:path])
    end

    def checksum(content)
      md5(content)
    end

    # what path to copy from
    def source_path
      raise NotImplementedError
    end

    def mode
      0644
    end

    def cert_details
      return @cert_details if defined? @cert_details
      if cert_resource = @resource[:key_pair]
        name = cert_resource.to_hash[:name]
        @cert_details = Puppet::Provider::KatelloSslTool::Cert.details(name)
      else
        raise 'Cert or Ca was not specified'
      end
    end

  end

end
