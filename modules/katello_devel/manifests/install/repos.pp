# Set up a repository for Katello
define katello_devel::install::repos (

  $repo = nightly,
  $gpgcheck = true

  ) {

  case $::osfamily {
    'RedHat': {
      katello::install::repos::yum { $name:
        repo     => $repo,
        gpgcheck => $gpgcheck,
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
}
