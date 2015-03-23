# Pulp Admin Install Packages
class pulp::admin::install {
  package { 'pulp-admin-client':
    ensure => $pulp::admin::version,
  }

  if $pulp::admin::puppet {
    package { 'pulp-puppet-admin-extensions':
      ensure => $pulp::admin::version,
    }
  }

  if $pulp::admin::docker {
    package { 'pulp-docker-admin-extensions':
      ensure => $pulp::admin::version,
    }
  }

  if $pulp::admin::nodes {
    package { 'pulp-nodes-admin-extensions':
      ensure => $pulp::admin::version,
    }
  }

  if $pulp::admin::python {
    package { 'pulp-python-admin-extensions':
      ensure => $pulp::admin::version,
    }
  }

  if $pulp::admin::rpm {
    package { 'pulp-rpm-admin-extensions':
      ensure => $pulp::admin::version,
    }
  }
}
