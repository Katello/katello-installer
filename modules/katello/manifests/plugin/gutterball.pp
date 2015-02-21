# gutterball plugin
class katello::plugin::gutterball{

  Class[ 'certs' ] ->
  class { 'certs::gutterball': } ->
  foreman::plugin { 'gutterball': } ->
  class { '::gutterball':
    amqp_broker_host  => $::fqdn,
    amqp_broker_port  => $::qpid::ssl_port,
    keystore_password => $certs::gutterball::gutterball_keystore_password,
  } ~>
  class { 'katello::plugin::gutterball::config':
    foreman_plugins_dir => $katello::config_dir,
    foreman_user        => $katello::user,
    foreman_group       => $katello::group,
  }
}
