require 'spec_helper'

describe 'pulp' do

 context 'on redhat' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
    end

    it { should contain_class('pulp::install') }
    it { should contain_class('pulp::config') }
    it { should contain_class('pulp::service') }
  end

end
