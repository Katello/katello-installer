require 'fileutils'
require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:cert).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::Cert) do

  def generate!
    resource[:common_name] ||= resource[:hostname]
    purpose = resource[:purpose]
    katello_ssl_tool("--gen-#{purpose}",
                     '-p', ca_details[:passphrase],
                     '--set-hostname', resource[:hostname],
                     '--set-common-name', resource[:common_name],
                     '--ca-cert', ca_details[:pubkey],
                     '--ca-key', ca_details[:privkey],
                     '--server-cert', File.basename(pubkey),
                     '--server-cert-req', "#{File.basename(pubkey)}.req",
                     '--server-key', File.basename(privkey),
                     '--server-rpm', rpmfile_base_name,
                     *common_args)
  end

  protected

  def build_path(file_name)
    self.class.build_path(File.join(resource[:hostname], file_name))
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
