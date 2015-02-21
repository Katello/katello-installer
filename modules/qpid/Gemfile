source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.4.0'
  gem "puppet-lint"
  gem "rspec-core", "< 3.2.0" # https://github.com/rspec/rspec-core/issues/1864
  gem "rspec-puppet", '>= 1'
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper", '>= 0.8.0'
  gem 'rspec-puppet-facts'
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "beaker"
  gem "beaker-rspec"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end
