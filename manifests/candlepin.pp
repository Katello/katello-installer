# Constains certs specific configurations for candlepin
class certs::candlepin (
    $hostname               = $::certs::node_fqdn,
    $generate               = $::certs::generate,
    $regenerate             = $::certs::regenerate,
    $deploy                 = $::certs::deploy,
    $ca                     = $::certs::default_ca,
    $storage                = $::certs::params::candlepin_certs_storage,
    $ca_cert                = $::certs::params::candlepin_ca_cert,
    $ca_key                 = $::certs::params::candlepin_ca_key,
    $pki_dir                = $::certs::params::candlepin_pki_dir,
    $keystore               = $::certs::params::candlepin_keystore,
    $keystore_password_file = $::certs::params::candlepin_keystore_password_file,
    $keystore_password      = $::certs::params::candlepin_keystore_password,
    $candlepin_certs_dir    = $::certs::params::candlepin_certs_dir
  ) inherits certs::params {

  Exec { logoutput => 'on_failure' }

  if $deploy {
    file { $keystore_password_file:
      ensure  => file,
      content => $keystore_password,
      mode    => '0644',
      owner   => 'tomcat',
      group   => $::certs::user_groups,
      replace => false;
    } ~>
    file { $pki_dir:
      ensure => directory,
      owner  => 'root',
      group  => $::certs::user_groups,
      mode   => '0750',
    } ~>
    pubkey { $ca_cert:
      cert => $ca,
    } ~>
    file { $ca_cert:
      owner   => 'root',
      group   => $::certs::user_groups,
      mode    => '0644';
    } ~>
    privkey { $ca_key:
      cert      => $ca,
      unprotect => true;
    } ~>
    file { $ca_key:
      owner   => 'root',
      group   => $::certs::user_groups,
      mode    => '0640';
    } ~>
    exec { 'generate-ssl-keystore':
      command   => "openssl pkcs12 -export -in ${ca_cert} -inkey ${ca_key} -out ${keystore} -name tomcat -CAfile ${ca_cert} -caname root -password \"file:${keystore_password_file}\"",
      path      => '/bin:/usr/bin',
      creates   => $keystore;
    } ~>
    file { "/usr/share/${candlepin::tomcat}/conf/keystore":
      ensure  => link,
      target  => $keystore;
    } ~>
    exec { 'add-candlepin-cert-to-nss-db':
      command     => "certutil -A -d '${::certs::nss_db_dir}' -n 'ca' -t 'TCu,Cu,Tuw' -a -i '${ca_cert}'",
      path        => '/usr/bin',
      subscribe   => Exec['create-nss-db'],
      refreshonly => true,
    }

  }
}
