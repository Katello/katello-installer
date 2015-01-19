# gutterball plugin
class katello::plugin::gutterball{
  Class[ 'certs' ] ->
  class { 'certs::gutterball': } ->
  foreman::plugin { 'gutterball': } ->
  class { '::gutterball':
    keystore_password => $certs::gutterball::gutterball_keystore_password,
  }
}
