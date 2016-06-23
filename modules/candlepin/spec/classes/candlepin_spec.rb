require 'spec_helper'

describe 'candlepin' do

  context 'on rhel6' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6',
        :osfamily                   => 'RedHat',
      }
    end

    it { should contain_class('candlepin::install') }
    it { should contain_class('candlepin::config') }
    it { should contain_class('candlepin::database') }
    it { should contain_class('candlepin::service') }
    it { should contain_service('tomcat6').with_ensure('running') }


  end

  context 'on rhel7' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '7.0',
        :operatingsystemmajrelease  => '7',
        :osfamily                   => 'RedHat',
      }
    end

    it { should contain_class('candlepin::install') }
    it { should contain_class('candlepin::config') }
    it { should contain_class('candlepin::database') }
    it { should contain_class('candlepin::service') }
    it { should contain_service('tomcat').with_ensure('running') }
  end

end
