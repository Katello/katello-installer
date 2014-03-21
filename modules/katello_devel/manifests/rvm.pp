# Setup and create gemset for RVM
class katello_devel::rvm {

  class { '::rvm': }

  rvm::system_user { $katello_devel::user: ; }

  rvm_system_ruby { 'ruby-1.9.3-p448':
    ensure      => 'present',
    default_use => true,
    build_opts  => ['--binary'],
  }

  rvm_gem { 'bundler':
    ensure       => latest,
    name         => 'bundler',
    ruby_version => 'ruby-1.9.3-p448',
    require      => Rvm_system_ruby['ruby-1.9.3-p448'],
  }

}
