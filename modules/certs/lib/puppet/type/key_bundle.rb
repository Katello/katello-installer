require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:key_bundle) do
  desc 'Stores the public and private key in one file file on a location'

  instance_eval(&Certs::FILE_COMMON_PARAMS)

  newparam(:pubkey)

  newparam(:privkey)

  # Whether to strip the certificate information from the pubkey
  newparam(:strip)
end
