# Pulp Installation Packages
class capsule::install {

  if $capsule::pulp or $capsule::pulp_master {
    package{ ['rubygem-smart_proxy_pulp']:
      ensure => installed,
    }
  }

  package{ ['katello-debug']:
    ensure => installed,
  }
}
