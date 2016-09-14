require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe 'validate_file_exists' do
  it { should run.with_params('foo_doesnt_exist').and_raise_error(Puppet::ParseError) }
  it { should run.with_params('foo_doesnt_exist').and_raise_error(/foo_doesnt_exist does not exist/) }
end
