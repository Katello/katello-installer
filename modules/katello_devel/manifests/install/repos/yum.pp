# Install a yum repo
define katello_devel::install::repos::yum ($repo, $gpgcheck) {
  $repo_path = $repo ? {
    default  => $repo,
  }
  $gpgcheck_enabled_default = $gpgcheck ? {
    false   => '0',
    default => '1',
  }
  $gpgcheck_enabled = $repo ? {
    'nightly' => '0',
    default   => $gpgcheck_enabled_default,
  }
  $os = $::operatingsystem ? {
    'CentOS'  => 'RHEL',
    'OracleLinux'  => 'RHEL',
    'RHEL'    => 'RHEL',
    'Fedora'  => 'Fedora'
  }
  yumrepo { $name:
    descr    => "Katello ${repo}",
    baseurl  => "http://fedorapeople.org/groups/katello/releases/yum/${repo_path}/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '1',
  }
  yumrepo { "${name}-source":
    descr    => "Katello ${repo} source",
    baseurl  => "http://fedorapeople.org/groups/katello/sources/yum/${repo_path}/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '0',
  }
  yumrepo { 'katello-candlepin':
    descr    => "Katello Candlepin ${repo}",
    baseurl  => "http://fedorapeople.org/groups/katello/releases/yum/katello-candlepin/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '1',
  }
  yumrepo { 'katello-candlepin-source':
    descr    => "Katello Candlepin ${repo} source",
    baseurl  => "http://fedorapeople.org/groups/katello/sources/yum/katello-candlepin/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '0',
  }
  yumrepo { 'katello-pulp':
    descr    => "Katello Pulp ${repo}",
    baseurl  => "http://fedorapeople.org/groups/katello/releases/yum/katello-pulp/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '1',
  }
  yumrepo { 'katello-pulp-source':
    descr    => "Katello Pulp ${repo} source",
    baseurl  => "http://fedorapeople.org/groups/katello/sources/yum/katello-pulp/${os}/\$releasever/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => 'http://www.katello.org/gpg/RPM-GPG-KEY-katello-2012.gpg',
    enabled  => '0',
  }
}
