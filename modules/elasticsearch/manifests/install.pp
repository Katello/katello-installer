# Install Elasticsearch and dependencies
class elasticsearch::install {

  $java_package = 'java-1.7.0-openjdk'

  package {['elasticsearch', $java_package]:
    ensure => 'installed',
  }
}
