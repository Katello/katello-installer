require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:pubkey).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::CertFile) do

  protected

  def expected_content
    if resource[:strip]
      # strips the textual info from the certificate file
      openssl('x509', '-in', source_path)
    else
      File.read(source_path)
    end
  end

  def source_path
    cert_details[:pubkey]
  end

end
