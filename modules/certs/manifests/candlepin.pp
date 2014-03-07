# Constains certs specific configurations for candlepin
class certs::candlepin (

  $hostname               = $::certs::node_fqdn,
  $generate               = $::certs::generate,
  $regenerate             = $::certs::regenerate,
  $deploy                 = $::certs::deploy,
  $ca                     = $::certs::default_ca,
  $storage                = $::certs::params::candlepin_certs_storage,
  $ca_cert                = $::certs::ca_cert_stripped,
  $ca_key                 = $::certs::ca_key,
  $pki_dir                = $::certs::params::pki_dir,
  $keystore               = $::certs::params::candlepin_keystore,
  $keystore_password_file = $::certs::params::keystore_password_file,
  $candlepin_certs_dir    = $::certs::params::candlepin_certs_dir

  ) inherits certs::params {

  Exec { logoutput => 'on_failure' }

  $keystore_password = cache_data($keystore_password_file, random_password(32))
  $password_file = "${certs::pki_dir}/keystore_password-file"

  if $deploy {

    file { $password_file:
      ensure  => file,
      content => $keystore_password,
      owner   => $certs::user,
      group   => $certs::group,
      mode    => '0440',
    } ~>
    exec { 'generate-ssl-keystore':
      command   => "openssl pkcs12 -export -in ${ca_cert} -inkey ${ca_key} -out ${keystore} -name tomcat -CAfile ${ca_cert} -caname root -password \"file:${password_file}\" -passin \"file:${certs::ca_key_password_file}\" ",
      path      => '/bin:/usr/bin',
      creates   => $keystore,
    } ~>
    file { "/usr/share/${candlepin::tomcat}/conf/keystore":
      ensure  => link,
      target  => $keystore,
      owner   => 'tomcat',
      group   => $::certs::group,
      notify  => Service[$candlepin::tomcat]
    }

  }
}
