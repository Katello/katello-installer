require 'spec_helper'

describe 'katello' do
 context 'on redhat' do
   let(:params) do
     {:user => 'foreman'}
   end
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6.4',
        :osfamily                   => 'RedHat',
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
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'OracleLinux',
        :operatingsystemrelease     => '6.5',
        :operatingsystemmajrelease  => '6.5',
        :osfamily                   => 'RedHat',
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello::install') }
    it { should contain_class('katello::config') }
    it { should contain_class('katello::service') }
  end

end
