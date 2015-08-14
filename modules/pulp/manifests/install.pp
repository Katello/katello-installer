# Pulp Installation Packages
class pulp::install {

  package{ ['pulp-server', 'pulp-selinux', 'pulp-docker-plugins', 'python-gofer-qpid',
            'pulp-rpm-plugins', 'pulp-puppet-plugins', 'pulp-nodes-parent']:
    ensure => installed,
    notify => Exec['migrate_again'],
  }

}
