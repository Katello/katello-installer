require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:privkey) do
  desc 'Stores the private key file in a location'

  instance_eval(&Certs::FILE_COMMON_PARAMS)

  # to make the key unprotected by the passphrase
  newparam(:unprotect)
end
