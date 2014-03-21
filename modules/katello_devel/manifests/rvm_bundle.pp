# Run a bundle command under RVM
define katello_devel::rvm_bundle() {

  exec { "rvm-bundle-${title}":
    cwd       => "${katello_devel::deployment_dir}/foreman",
    command   => "sudo su ${katello_devel::user} -c '/bin/bash --login -c \"rvm use ${katello_devel::rvm_ruby} && bundle ${title}\"'",
    user      => $::katello_devel::user,
    logoutput => 'on_failure',
    timeout   => '600',
    path      => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/bin/env',
  }

}
