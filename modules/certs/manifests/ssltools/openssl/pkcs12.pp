# type that coresponds the openssl pkcs12 subcommand
define certs::ssltools::openssl::pkcs12 ( $cert_name, $ca_cert, $ca_key, $ca_name, $keystore_out, $password_out, $password_in = undef, $refreshonly = false) {
  $password_in_options = $password_in ? {
    undef   => '',
    default => "-passin \"pass:${password_in}\"",
  }
  exec { $title:
    command     => "openssl pkcs12 -export -in ${ca_cert} -inkey ${ca_key} -out ${keystore_out} -name ${cert_name} -CAfile ${ca_cert} -caname ${ca_name} -password \"file:${password_out}\" ${password_in_options}",
    creates     => $keystore_out,
    refreshonly => $refreshonly,
    path        => ['/bin/', '/usr/bin'],
    logoutput   => true,
  }
}
