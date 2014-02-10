require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:pubkey) do
  desc 'Stores the public key file on a location'

  instance_eval(&Certs::FILE_COMMON_PARAMS)
end
