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

      passphrase_file = passphrase_file(cert_name)
      if File.exists?(passphrase_file)
        details[:passphrase] = File.read(passphrase_file).chomp
      end

      return details
    end

    def self.pubkey(name)
      # TODO: just temporarily until we have this changes in katello installer as well
      if name == 'candlepin-ca'
        '/usr/share/katello/candlepin-cert.crt'
      else
        target_path("certs/#{name}.crt")
      end
    end

    def self.privkey(name)
      # TODO: just temporarily until we have this changes in katello installer as well
      if name == 'candlepin-ca'
        build_path('candlepin-cert.key')
      else
        target_path("private/#{name}.key")
      end
    end

    def self.passphrase_file(name)
      # TODO: just temporarily until we have this changes in katello installer as well
      if name == 'candlepin-ca'
        '/etc/katello/candlepin_ca_password-file'
      else
        build_path("#{name}.pwd")
      end
    end

    protected

    def katello_ssl_tool(*args)
      Dir.chdir('/root') do
        katello_ssl_tool_command(*args)
      end
    end

    def generate?
      return false unless resource[:generate]
      return true if resource[:regenerate]
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

    def rpmfile_base_name
      resource[:name]
    end

    def pubkey
      self.class.pubkey(resource[:name])
    end

    def privkey
      self.class.privkey(resource[:name])
    end

    def passphrase_file
      self.class.passphrase_file(resource[:name])
    end

    def full_path(file_name)
      self.class.full_path(file_name)
    end

    def self.target_path(file_name = nil)
      File.join("/etc/pki/tls", file_name)
    end

    def build_path(file_name)
      self.class.build_path(file_name)
    end

    def self.build_path(file_name = nil)
      File.join("/root/ssl-build", file_name)
    end

  end

  class CertFile < Puppet::Provider

    include Puppet::Util::Checksums

    initvars

    def exists?
      return false unless File.exists?(resource[:path])
      checksum(expected_content) == checksum(current_content)
    end

    def create
      File.open(resource[:path], "w") { |f| f << expected_content }
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

    def cert_details
      return @cert_details if defined? @cert_details
      if cert_resource = @resource[:cert]
        name = cert_resource.to_hash[:name]
        @cert_details = Puppet::Provider::KatelloSslTool::Cert.details(name)
      else
        raise 'Cert was not specified'
      end
    end

  end

end
