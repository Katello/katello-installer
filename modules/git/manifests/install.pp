# = Class: git::install
#
# Installs required packages for git.
#
#
class git::install {
  package { $::git::package:
    ensure => $::git::package_ensure,
  }
}
