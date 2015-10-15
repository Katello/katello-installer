# Katello Install
class katello::install {
  package { $katello::package_names:
    ensure => installed,
  }
}
