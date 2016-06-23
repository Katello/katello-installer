require 'fileutils'
require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:cert).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::Cert) do

  def generate!
    args = [ "--gen-#{resource[:purpose]}",
              '--set-hostname', resource[:hostname],
              '--server-cert', File.basename(pubkey),
              '--server-cert-req', File.basename(req_file),
              '--server-key', File.basename(privkey),
              '--server-rpm', rpmfile_base_name ]
    if resource[:custom_pubkey]
      FileUtils.mkdir_p(build_path)
      FileUtils.cp(resource[:custom_pubkey], build_path(File.basename(pubkey)))
      FileUtils.cp(resource[:custom_privkey], build_path(File.basename(privkey)))
      FileUtils.cp(resource[:custom_req], build_path(File.basename(req_file)))
      args << '--rpm-only'
    else
      resource[:common_name] ||= resource[:hostname]
      args.concat(['-p', "file:#{resource[:password_file]}",
                   '--set-hostname', resource[:hostname],
                   '--set-common-name', resource[:common_name],
                   '--ca-cert', ca_details[:pubkey],
                   '--ca-key', ca_details[:privkey]])
      args.concat(common_args)
    end
    katello_ssl_tool(*args)
    super
  end

  protected

  def req_file
    "#{self.pubkey}.req"
  end

  def build_path(file_name = '')
    self.class.build_path(File.join(resource[:hostname], file_name))
  end
end
