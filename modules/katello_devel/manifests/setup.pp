# Handles initialization and setup of the Rails app
class katello_devel::setup {

  if $katello_devel::use_rvm {

    $seed_env = {
      'SEED_ORGANIZATION'   => $::katello_devel::initial_organization,
      'SEED_LOCATION'       => $::katello_devel::initial_location,
      'SEED_ADMIN_PASSWORD' => $::katello_devel::admin_password,
    }

    class { 'katello_devel::rvm': } ->
    katello_devel::rvm_bundle { 'install --without mysql:mysql2': } ->
    katello_devel::rvm_bundle { 'exec rake db:migrate': } ->
    katello_devel::rvm_bundle { 'exec rake db:seed':
      environment => $seed_env
    } ~>
    katello_devel::rvm_bundle {
      "exec rake -- config --key ssl_ca_file --value ${katello_devel::foreman_certs::ssl_ca_cert}":
    } ~>
    katello_devel::rvm_bundle {
      "exec rake -- config --key ssl_certificate --value ${katello_devel::foreman_certs::client_cert}":
    } ~>
    katello_devel::rvm_bundle {
      "exec rake -- config --key ssl_priv_key --value ${katello_devel::foreman_certs::client_key}":
    } ~>
    exec { 'rails server':
      cwd       => "${katello_devel::deployment_dir}/foreman",
      command   => "sudo su ${katello_devel::user} -c '/bin/bash --login -c \"rvm use ${katello_devel::rvm_ruby} && bundle exec rails s -d\"'",
      user      => $::katello_devel::user,
      logoutput => 'on_failure',
      timeout   => '600',
      path      => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/bin/env',
      unless    =>  'ps -p `cat tmp/pids/server.pid`',
      before    => Class['capsule']
    }

    exec { 'destroy rails server':
      cwd       => "${katello_devel::deployment_dir}/foreman",
      require   => Class['foreman_proxy::register'],
      path      => '/usr/bin:/bin:/usr/bin/env',
      command   => 'kill -9 `cat tmp/pids/server.pid`',
      logoutput => 'on_failure',
      timeout   => '600',
    }
  }


}
