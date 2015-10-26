# = Definition: git::repo
#
# == Parameters:
#
# $target::   Target folder. Required.
#
# $bare::     Create a bare repository. Defaults to false.
#
# $source::   Source to clone from. If not specified, no remote will be used.
#
# $user::     Owner of the repository. Defaults to root.
#
# == Usage:
#
#   git::repo {'mygit':
#     target => '/home/user/puppet-git',
#     source => 'git://github.com/theforeman/puppet-git.git',
#     user   => 'user',
#   }
#
define git::repo (
  $target,
  $bare    = false,
  $source  = false,
  $user    = 'root',
  $workdir = '/tmp',
) {

  require git::params

  if $source {
    $cmd = "${::git::params::bin} clone ${source} ${target} --recursive"
  } else {
    if $bare {
      $cmd = "${::git::params::bin} init --bare ${target}"
    } else {
      $cmd = "${::git::params::bin} init ${target}"
    }
  }

  $creates = $bare ? {
    true  => "${target}/objects",
    false => "${target}/.git",
  }

  exec { "git_repo_for_${name}":
    command => $cmd,
    creates => $creates,
    cwd     => $workdir,
    require => Class['git::install'],
    user    => $user,
  }
}
