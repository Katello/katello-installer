require 'fileutils'
require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:ca).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::Cert) do

  protected

  def generate!
    katello_ssl_tool('--gen-ca',
                     '-p', "file:#{resource[:password_file]}",
                     '--force',
                     '--ca-cert-dir', target_path('certs'),
                     '--set-common-name', resource[:common_name],
                     '--ca-cert', File.basename(pubkey),
                     '--ca-key', File.basename(privkey),
                     '--ca-cert-rpm', rpmfile_base_name,
                     *common_args)
  end

  def files_to_generate
    [rpmfile, privkey]
  end

  def files_to_deploy
    [pubkey]
  end

  def self.privkey(name)
    build_path("#{name}.key")
  end

end
