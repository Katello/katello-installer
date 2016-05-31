# Constains certs specific configurations for gutterball
class certs::gutterball(

  $hostname               = $::certs::node_fqdn,
  $generate               = $::certs::generate,
  $regenerate             = $::certs::regenerate,
  $deploy                 = $::certs::deploy,
  $pki_dir                = $::certs::pki_dir,
  $password_file          = $::certs::gutterball_keystore_password_file,
  $amqp_truststore        = $::certs::gutterball_amqp_truststore,
  $amqp_keystore          = $::certs::gutterball_amqp_keystore,
  $amqp_store_dir         = $::certs::gutterball_amqp_store_dir,

) inherits certs::params {
  $keystore_alias = 'gutterball'
  $ca_key = $::certs::ca_key
  $ca = $::certs::ca_cert_stripped
  $key = "${pki_dir}/gutterball.key"
  $cert = "${pki_dir}/gutterball.crt"

  $gutterball_keystore_password = cache_data('foreman_cache_data', 'gutterball_keystore_password', random_password(32))

  $keypair= 'gutterball-certs'

  cert { $keypair:
    ensure        => present,
    hostname      => $hostname,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::city,
    org           => 'gutterball',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }
  if $deploy {
    file { $certs::gutterball_certs_dir:
      ensure => directory,
      owner  => 'tomcat',
      group  => $::certs::group,
      mode   => '0755',
    } ->
    Cert[$keypair] ~>
    privkey { $key:
      key_pair => Cert[$keypair],
    } ~>
    pubkey { $cert:
      key_pair => Cert[$keypair],
    } ->
    file { $password_file:
      ensure  => file,
      content => $gutterball_keystore_password,
      owner   => $certs::user,
      group   => $certs::group,
      mode    => '0440',
    } ->
    certs::ssltools::certutil{ 'guterball-amqp-client':
      nss_db_dir  => $::certs::nss_db_dir,
      client_cert => $cert,
    } ->
    file { $amqp_store_dir:
      ensure => directory,
      owner  => 'tomcat',
      group  => $::certs::group,
      mode   => '0750',
    } ->
    file { "${certs::gutterball_certs_dir}/gutterball.key":
      ensure => 'link',
      target => $key,
    } ->
    file { "${certs::gutterball_certs_dir}/gutterball.crt":
      ensure => 'link',
      target => $cert,
    } ->
    certs::ssltools::keytool::import_ca { 'import CA into gutterball truststore':
      keystore       => $amqp_truststore,
      password       => $gutterball_keystore_password,
      keystore_alias => $keystore_alias,
      file           => $ca,
    } ~>
    certs::ssltools::keytool::import_keypair{ 'import client certificate into gutterball keystore':
      keystore_alias    => $keystore_alias,
      keystore          => $amqp_keystore,
      keystore_password => $gutterball_keystore_password,
      cert              => $cert,
      key               => $key,
      tmp_password_file => $password_file,
    } ~>
    file { $amqp_keystore:
      ensure => file,
      owner  => 'tomcat',
      group  => $::certs::group,
      mode   => '0640',
    }
  }
}
