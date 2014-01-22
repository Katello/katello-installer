# Install Elasticsearch and dependencies
class elasticsearch::install {
  package {['elasticsearch', 'java-1.6.0-openjdk']:
    ensure => 'installed'
  }
}
