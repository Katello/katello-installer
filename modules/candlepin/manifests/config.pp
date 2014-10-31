# Configuration for Candlepin
class candlepin::config {

  user { 'tomcat':
    ensure => present,
    groups => $candlepin::user_groups,
  }

  file { '/etc/candlepin':
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'tomcat',
  }

  concat{$::candlepin::candlepin_conf_file:
    mode  => '0600',
    owner => 'tomcat',
    group => 'tomcat',
  }

  concat::fragment {'General Config':
    target  => $::candlepin::candlepin_conf_file,
    content => template('candlepin/candlepin.conf.erb'),
  }

  file { "/etc/${candlepin::tomcat}":
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'tomcat',
  }

  file { "/etc/${candlepin::tomcat}/server.xml":
    ensure  => file,
    content => template("candlepin/${candlepin::tomcat}/server.xml.erb"),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  file { '/var/log/candlepin':
    ensure => directory,
    mode   => '0775',
    owner  => 'tomcat',
    group  => 'tomcat',
  }

  file { "/var/log/${candlepin::tomcat}":
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'tomcat',
  }

  file { "/var/lib/${candlepin::tomcat}":
    ensure => directory,
    mode   => '0775',
    owner  => 'tomcat',
    group  => 'tomcat',
  }

  file { "/var/cache/${candlepin::tomcat}":
    ensure => directory,
    mode   => '0775',
    owner  => 'tomcat',
    group  => 'tomcat',
  }

}
