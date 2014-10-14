# Pulp Installation Packages
class pulp::install {

  package{ ['pulp-server', 'pulp-selinux', 'pulp-docker-plugins', 'pulp-rpm-plugins', 'pulp-puppet-plugins', 'pulp-nodes-parent']:
    ensure => installed,
  }

}
