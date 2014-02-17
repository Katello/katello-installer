# Pulp Installation Packages
class pulp::install {

  package{ ['pulp-server', 'pulp-selinux', 'pulp-rpm-plugins', 'pulp-puppet-plugins', 'pulp-nodes-parent']:
    ensure => installed,
  }

}
