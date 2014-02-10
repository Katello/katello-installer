# Certs Configuration
class certs::config {

  file { $certs::pki_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $certs::group,
    mode    => '0750',
  }

}
