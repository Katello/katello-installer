require 'spec_helper'

describe 'pulp::child' do

 context 'on redhat' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
    end

    let :pre_condition do
      "class {'pulp':}"
    end

    let :params do {
      :parent_fqdn  => 'mamma-pulp'
    } end

    it { should contain_class('pulp::child::install') }
    it { should contain_class('pulp::child::config') }
    it { should contain_class('pulp::child::service') }

  end

end
