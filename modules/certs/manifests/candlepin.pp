# Constains certs specific configurations for candlepin
class certs::candlepin (

  $hostname               = $::certs::node_fqdn,
  $generate               = $::certs::generate,
  $regenerate             = $::certs::regenerate,
  $deploy                 = $::certs::deploy,
  $ca_cert                = $::certs::ca_cert_stripped,
  $ca_key                 = $::certs::ca_key,
  $pki_dir                = $::certs::params::pki_dir,
  $keystore               = $::certs::params::candlepin_keystore,
  $keystore_password_file = $::certs::params::keystore_password_file,
  $amqp_truststore        = $::certs::params::candlepin_amqp_truststore,
  $amqp_keystore          = $::certs::params::candlepin_amqp_keystore,
  $amqp_store_dir         = $::certs::params::candlepin_amqp_store_dir,

  ) inherits certs::params {

  Exec {
    logoutput => 'on_failure',
    path      => ['/bin/', '/usr/bin']
  }

  $java_client_cert_name= 'java-client'

  cert { $java_client_cert_name:
    ensure        => present,
    hostname      => $hostname,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'candlepin',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  $keystore_password = cache_data($keystore_password_file, random_password(32))
  $password_file = "${certs::pki_dir}/keystore_password-file"
  $client_req = "${certs::pki_dir}/java-client.req"
  $client_cert = "${certs::pki_dir}/certs/${java_client_cert_name}.crt"
  $client_key = "${certs::pki_dir}/private/${java_client_cert_name}.key"

  if $deploy {

    file { $password_file:
      ensure  => file,
      content => $keystore_password,
      owner   => $certs::user,
      group   => $certs::group,
      mode    => '0440',
    } ~>
    exec { 'candlepin-generate-ssl-keystore':
      command   => "openssl pkcs12 -export -in ${ca_cert} -inkey ${ca_key} -out ${keystore} -name tomcat -CAfile ${ca_cert} -caname root -password \"file:${password_file}\" -passin \"file:${certs::ca_key_password_file}\" ",
      creates   => $keystore,
    } ~>
    file { "/usr/share/${candlepin::tomcat}/conf/keystore":
      ensure  => link,
      target  => $keystore,
      owner   => 'tomcat',
      group   => $::certs::group,
      notify  => Service[$candlepin::tomcat]
    }

    Cert[$java_client_cert_name] ~>
    pubkey { $client_cert:
      key_pair => Cert[$java_client_cert_name]
    } ~>
    privkey { $client_key:
      key_pair => Cert[$java_client_cert_name]
    } ~>
    exec { 'candlepin-add-client-cert-to-nss-db':
      command     => "certutil -A -d '${::certs::nss_db_dir}' -n 'amqp-client' -t ',,' -a -i '${client_cert}'",
      refreshonly => true,
      subscribe   => Exec['create-nss-db'],
      notify      => Service['qpidd'],
    } ~>
    file { $amqp_store_dir:
      ensure => directory,
      owner  => 'tomcat',
      group  => $::certs::group,
      mode   => '0750',
    } ~>
    exec { 'create candlepin qpid exchange':
      command => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://${::fqdn}:5671' add exchange topic event --durable",
      unless  => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://${::fqdn}:5671' exchanges event",
    } ~>
    exec { 'import CA into Candlepin truststore':
      command  => "keytool -import -v -keystore ${amqp_truststore} -storepass ${keystore_password} -alias ${certs::default_ca_name} -file ${ca_cert} -noprompt",
      creates  => $amqp_truststore,
    } ~>
    exec { 'import client certificate into Candlepin keystore':
      # Stupid keytool doesn't allow you to import a keypair.  You can only import a cert.  Hence, we have to
      # create the store as an PKCS12 and convert to JKS.  See http://stackoverflow.com/a/8224863
      command  => "openssl pkcs12 -export -name amqp-client -in ${client_cert} -inkey ${client_key} -out /tmp/keystore.p12 -passout file:${password_file} && keytool -importkeystore -destkeystore ${amqp_keystore} -srckeystore /tmp/keystore.p12 -srcstoretype pkcs12 -alias amqp-client -storepass ${keystore_password} -srcstorepass ${keystore_password} -noprompt && rm /tmp/keystore.p12",
      unless   => "keytool -list -keystore ${amqp_keystore} -storepass ${keystore_password} -alias ${certs::default_ca_name}",
    } ~>
    file { $amqp_keystore:
      ensure   => file,
      owner    => 'tomcat',
      group    => $::certs::group,
      mode     => '0640',
      notify   => Service[$candlepin::tomcat],
    }
  }
}
