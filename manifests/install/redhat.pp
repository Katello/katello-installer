class passenger::install::redhat {
  case $::operatingsystem {
    'Fedora': {
      if $::operatingsystemrelease < 17 {
        include passenger::repo
      }
    }
    default: {
      if $::operatingsystemrelease =~ /^5\..+/ {
        include passenger::repo
      }
    }
  }

  package{'passenger':
    ensure  => installed,
    name    => 'mod_passenger',
    require => Class['apache::install'],
    before  => Class['apache::service'],
  }

}
