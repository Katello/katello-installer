# Handles initialization and setup of the Rails app
class katello_devel::setup {

  if $katello_devel::use_rvm {

    class { 'katello_devel::rvm': } ->
    katello_devel::rvm_bundle { 'install --without mysql:mysql2': } ->
    katello_devel::rvm_bundle { 'exec rake db:migrate': } ->
    katello_devel::rvm_bundle { 'exec rake db:seed': }

  }


}
