# = Class: git::params
#
# Configure how the puppet git module behaves
#
# == Parameters:
#
# $bin::      Path to git. Defaults to /usr/bin/git.
#
# $package::  Override the name of the git package(s) to include.
#
# == Usage:
#
# Example: Override the path to the git binary.
#
#   class {'git::params':
#     bin => '/usr/local/bin/git',
#   }
#
class git::params {
  case $::osfamily {
    /^(FreeBSD|DragonFly)$/: {
      $bin = '/usr/local/bin/git'
      $package = 'git'
      $package_ensure = 'installed'
    }
    default: {
      $bin = '/usr/bin/git'
      $package = 'git'
      $package_ensure = 'installed'
    }
  }
}
