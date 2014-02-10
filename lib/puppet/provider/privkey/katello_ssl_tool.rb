require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:privkey).provide(:katello_ssl_tool, :parent => Puppet::Provider::KatelloSslTool::CertFile) do

  protected

  def expected_content
    if resource[:unprotect]
      tmp_file = "#{source_path}.tmp"
      begin
        openssl('rsa',
                '-in', source_path,
                '-out', tmp_file,
                '-passin', "file:#{cert_details[:passphrase_file]}")
        File.read(tmp_file)
      ensure
        File.delete(tmp_file) if File.exists?(tmp_file)
      end
    else
      super
    end
  end

  def source_path
    cert_details[:privkey]
  end

  def mode
    0400
  end

end
