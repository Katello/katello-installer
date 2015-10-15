require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:cert) do
  desc 'ca signed cert'

  instance_eval(&Certs::CERT_COMMON_PARAMS)

  newparam(:hostname)

  newparam(:purpose) do
    defaultto 'server'
  end
end
