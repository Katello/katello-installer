require 'fileutils'
require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:ca).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::Cert) do

  protected

  def generate!
    if existing_pubkey
      FileUtils.mkdir_p(build_path)
      FileUtils.cp(existing_pubkey, build_path(File.basename(pubkey)))
      katello_ssl_tool('--gen-ca',
                       '--ca-cert-dir', target_path('certs'),
                       '--ca-cert', File.basename(pubkey),
                       '--ca-cert-rpm', rpmfile_base_name,
                       '--rpm-only')
    else
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
    super
  end

  def existing_pubkey
    if resource[:ca]
      ca_details[:pubkey]
    elsif resource[:custom_pubkey]
      resource[:custom_pubkey]
    end
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

  def files_to_deploy
    [pubkey]
  end

  def self.privkey(name)
    build_path("#{name}.key")
  end

end
