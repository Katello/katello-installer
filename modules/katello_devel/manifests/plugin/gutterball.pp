# gutterball plugin
class katello_devel::plugin::gutterball {
  Class[ 'certs' ] ->
  class { '::certs::gutterball': } ->
  class { '::gutterball':
    keystore_password => $certs::gutterball::gutterball_keystore_password,
  }
}
