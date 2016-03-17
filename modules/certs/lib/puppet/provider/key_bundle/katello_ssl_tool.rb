require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:key_bundle).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::CertFile) do

  protected

  def expected_content
    [privkey, pubkey].join("\n")
  end

  def pubkey
    if resource[:strip]
      # strips the textual info from the certificate file
      openssl('x509', '-in', pubkey_source_path)
    else
      File.read(pubkey_source_path)
    end
  end

  def privkey
    File.read(privkey_source_path)
  end

  def privkey_source_path
    resource[:privkey] || cert_details[:privkey]
  end

  def pubkey_source_path
    resource[:pubkey] || cert_details[:pubkey]
  end

end
