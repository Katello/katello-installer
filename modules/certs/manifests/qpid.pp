# Handles Qpid cert configuration
class certs::qpid (

  $hostname   = $::certs::node_fqdn,
  $generate   = $::certs::generate,
  $regenerate = $::certs::regenerate,
  $deploy     = $::certs::deploy,
  ){

  Exec { logoutput => 'on_failure' }

  $qpid_cert_name = "${certs::qpid::hostname}-qpid-broker"

  cert { $qpid_cert_name:
    ensure        => present,
    hostname      => $::certs::qpid::hostname,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'pulp',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {

    $nss_db_password_file   = "${certs::nss_db_dir}/nss_db_password-file"
    $client_cert            = "${certs::pki_dir}/certs/${qpid_cert_name}.crt"
    $client_key             = "${certs::pki_dir}/private/${qpid_cert_name}.key"
    $pfx_path               = "${certs::pki_dir}/${qpid_cert_name}.pfx"
    $nssdb_files            = ["${::certs::nss_db_dir}/cert8.db", "${::certs::nss_db_dir}/key3.db", "${::certs::nss_db_dir}/secmod.db"]

    Package['httpd'] -> Package['qpid-cpp-server'] ->
    Cert[$qpid_cert_name] ~>
    pubkey { $client_cert:
      key_pair => Cert["${::certs::qpid::hostname}-qpid-broker"]
    } ~>
    privkey { $client_key:
      key_pair => Cert["${::certs::qpid::hostname}-qpid-broker"]
    } ~>
    file { $client_key:
      ensure  => file,
      owner   => 'root',
      group   => 'apache',
      mode    => '0440',
    } ~>
    file { $::certs::nss_db_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'qpidd',
      mode   => '0755',
    } ~>
    exec { 'generate-nss-password':
      command => "openssl rand -base64 24 > ${nss_db_password_file}",
      path    => '/usr/bin',
      creates => $nss_db_password_file
    } ->
    file { $nss_db_password_file:
      ensure  => file,
      owner   => 'root',
      group   => 'qpidd',
      mode    => '0640',
    } ~>
    exec { 'create-nss-db':
      command => "certutil -N -d '${::certs::nss_db_dir}' -f '${nss_db_password_file}'",
      path    => '/usr/bin',
      creates => $nssdb_files,
    } ~>
    exec { 'add-ca-cert-to-nss-db':
      command     => "certutil -A -d '${::certs::nss_db_dir}' -n 'ca' -t 'TCu,Cu,Tuw' -a -i '${certs::ca_cert}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    file { $nssdb_files:
      owner   => 'root',
      group   => 'qpidd',
      mode    => '0640',
    } ~>
    exec { 'add-broker-cert-to-nss-db':
      command     => "certutil -A -d '${::certs::nss_db_dir}' -n 'broker' -t ',,' -a -i '${client_cert}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    exec { 'generate-pfx-for-nss-db':
      command     => "openssl pkcs12 -in ${client_cert} -inkey ${client_key} -export -out '${pfx_path}' -password 'file:${nss_db_password_file}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    exec { 'add-private-key-to-nss-db':
      command     => "pk12util -i '${pfx_path}' -d '${::certs::nss_db_dir}' -w '${nss_db_password_file}' -k '${nss_db_password_file}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    Service['qpidd']

  }

}
