# Certs Installation
class certs::install {
  package{['katello-certs-tools']:
    ensure => installed,
  }
}
