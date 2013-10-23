class pulp::install {
  package{['pulp-server', 'pulp-selinux', 'pulp-rpm-plugins']:
    ensure => installed,
  }
}
