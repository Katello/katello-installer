# type to append cert to nssdb
define certs::ssltools::certutil($nss_db_dir, $client_cert, $cert_name=$title, $refreshonly = true) {
  Exec['create-nss-db'] ->
  exec { "delete ${cert_name}":
    path        => ['/bin', '/usr/bin'],
    command     => "certutil -D -d ${nss_db_dir} -n '${cert_name}'",
    onlyif      => "certutil -L -d ${nss_db_dir} | grep '${cert_name}'",
    logoutput   => true,
    refreshonly => $refreshonly,
  } ->
  exec { $cert_name:
    path        => ['/bin', '/usr/bin'],
    command     => "certutil -A -d '${nss_db_dir}' -n '${cert_name}' -t ',,' -a -i '${client_cert}'",
    unless      => "certutil -L -d ${nss_db_dir} | grep '${cert_name}'",
    logoutput   => true,
    refreshonly => $refreshonly,
  }
}
