require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:key_bundle).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::CertFile) do

  protected

  def expected_content
    [privkey, pubkey].map { |f| File.read(f) }.join("\n")
  end

  def privkey
    resource[:privkey] || cert_details[:privkey]
  end

  def pubkey
    resource[:pubkey] || cert_details[:pubkey]
  end

end
