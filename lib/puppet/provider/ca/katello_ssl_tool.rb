require 'fileutils'
require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:ca).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::Cert) do

  def self.privkey(name)
    # TODO: just temporarily until we have this changes in katello installer as well
    if name == 'candlepin-ca'
      build_path('candlepin-cert.key')
    else
      target_path("private/#{name}.key")
    end
  end

  protected

  def generate_passphrase
    @passphrase ||= generate_random_password
    passphrase_dir = File.dirname(passphrase_file)
    FileUtils.mkdir_p(passphrase_dir) unless File.exists?(passphrase_dir)
    File.open(passphrase_file, 'w') { |f| f << @passphrase }
    return @passphrase
  end

  def generate!
    passphrase = generate_passphrase
    katello_ssl_tool('--gen-ca',
                     '-p', passphrase,
                     '--force',
                     '--set-common-name', resource[:common_name],
                     '--ca-cert', File.basename(pubkey),
                     '--ca-key', File.basename(privkey),
                     '--ca-cert-rpm', rpmfile_base_name,
                     *common_args)
  end

  def files_to_generate
    [rpmfile, privkey, passphrase_file]
  end

  def files_to_deploy
    [pubkey]
  end

  # TODO: just temporarily until we have this changes in katello installer as well
  def rpmfile_base_name
    if resource[:name] == 'candlepin-ca'
      'katello-candlepin-cert-key-pair'
    else
      super
    end
  end

  def generate_random_password
    size = 20
    # These are quite often confusing ...
    ambiguous_characters = %w(0 1 O I l)

    # Get allowed characters set ...
    set = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('0' .. '9').to_a
    set = set - ambiguous_characters

    # Shuffle characters in the set at random and return desired number of them ...
    return size.times.collect {|i| set[rand(set.size)] }.join
  end

end
