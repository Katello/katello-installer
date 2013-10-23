require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:privkey) do
  desc 'Stores the private key file on a location'

  instance_eval(&Certs::FILE_COMMON_PARAMS)
end
