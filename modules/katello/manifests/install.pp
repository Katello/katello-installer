# Katello Install
class katello::install {
  if ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora'){
    $os = 'RHEL'
  } else {
    $os = 'Fedora'
  }
  $package = $os ? {
    'RHEL'   => 'ruby193-rubygem-katello',
    'Fedora' => 'rubygem-katello'
  }
  package{[$package]:
    ensure => installed,
  }
}
