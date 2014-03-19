# Install Elasticsearch and dependencies
class elasticsearch::install {

  case $::operatingsystem {
    'Fedora': {
      $java_package = 'java-1.7.0-openjdk'
    }
    default: {
      $java_package = 'java-1.6.0-openjdk'
    }
  }
  package {['elasticsearch', $java_package]:
    ensure => 'installed'
  }
}
