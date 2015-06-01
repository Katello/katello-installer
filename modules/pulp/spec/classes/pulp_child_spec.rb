require 'spec_helper'

describe 'pulp::child' do

 context 'on redhat' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.4',
        :operatingsystemmajrelease => '6.4',
        :osreleasemajor            => '6',
        :osfamily                  => 'RedHat',
        :processorcount            => 3,
      }
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
