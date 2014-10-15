# Katello Install
class katello::install {

  $os = $::operatingsystem ? {
    'RedHat' => 'RHEL',
    'CentOS' => 'RHEL',
    default  => 'Fedora'
  }

  $package = $os ? {
    'RHEL'   => 'ruby193-rubygem-katello',
    'Fedora' => 'rubygem-katello'
  }

  package{[$package]:
    ensure => installed,
  }

}
