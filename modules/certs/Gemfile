source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.6']
end

gem 'rake'
gem 'puppet',  puppetversion
gem 'puppet-lint', '~> 0.3.2'
