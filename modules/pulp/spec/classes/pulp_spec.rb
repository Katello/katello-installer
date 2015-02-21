require 'spec_helper'

describe 'pulp' do

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

    it { should contain_class('pulp::install') }
    it { should contain_class('pulp::config') }
    it { should contain_class('pulp::service') }
  end

end
