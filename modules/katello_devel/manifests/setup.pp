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
    }

  }


}
