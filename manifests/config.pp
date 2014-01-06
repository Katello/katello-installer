# Configure Elasticsearch
class elasticsearch::config {
  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('elasticsearch/etc/elasticsearch/elasticsearch.yml.erb')
  }

  file { '/var/run/elasticsearch':
    ensure => directory,
    mode   => '0644',
    owner  => 'elasticsearch',
    group  => 'elasticsearch'
  }

  file { '/etc/sysconfig/elasticsearch':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('elasticsearch/etc/sysconfig/elasticsearch.erb')
  }

  if $elasticsearch::reset_data == 'YES' {
    exec {'reset_elasticsearch_data':
      command => 'rm -rf /var/lib/elasticsearch/*',
      path    => '/sbin:/bin:/usr/bin'
    }
  }
}
