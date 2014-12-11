require 'spec_helper'

describe 'katello' do
  context 'on redhat' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :osfamily                  => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

  context 'on centos' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'CentOS',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :osfamily                  => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

  context 'on oel' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'OracleLinux',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :osfamily                  => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

  context 'on fedora' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'Fedora',
        :operatingsystemrelease    => '20',
        :operatingsystemmajrelease => '20',
        :osfamily                  => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

  context 'on sl' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'ScientificLinux',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :osfamily                  => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :hostname                  => 'localhost',
        :operatingsystem           => 'UNSUPPORTED OPERATINGSYSTEM',
        :operatingsystemmajrelease => '1',
        :operatingsystemrelease    => '1',
        :osfamily                  => 'UNSUPPORTED OSFAMILY',
      }
    end

    it { expect { should contain_class('katello') }.to raise_error(Puppet::Error, /#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/) }
  end

end
