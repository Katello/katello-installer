require 'spec_helper'

describe 'candlepin::install' do

  context 'on el6' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6',
        :osfamily                   => 'RedHat',
      }
    end

    let :pre_condition do
      "class {'candlepin':}"
    end

    it { should contain_package('candlepin').with('ensure' => 'installed') }
    it { should contain_package('candlepin-tomcat6').with('ensure' => 'installed') }
  end

  context 'on el7' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '7.0',
        :operatingsystemmajrelease  => '7',
        :osfamily                   => 'RedHat',
      }
    end

    let :pre_condition do
      "class {'candlepin':}"
    end

    it { should contain_package('candlepin').with('ensure' => 'installed') }
    it { should contain_package('candlepin-tomcat').with('ensure' => 'installed') }
  end
end
