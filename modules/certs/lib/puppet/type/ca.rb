require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:ca) do
  desc 'Ca for generating signed certs'

  instance_eval(&Certs::CERT_COMMON_PARAMS)

end
