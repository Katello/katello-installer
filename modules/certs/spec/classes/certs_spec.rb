require 'spec_helper'

describe 'certs' do

 context 'on redhat' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :puppetversion => Puppet.version)
    end

    it { should contain_class('certs::install') }
    it { should contain_class('certs::config') }
  end

end
