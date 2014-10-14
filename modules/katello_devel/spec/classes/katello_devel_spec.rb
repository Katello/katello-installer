require 'spec_helper'

describe 'katello_devel' do

 context 'on redhat' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6.4',
        :osfamily                   => 'RedHat',
      }
    end

    let(:params) do
      {
        :user => 'vagrant'
      }
    end

    let(:pre_condition) do
      ['include foreman','include certs']
    end

    it { should contain_class('katello_devel::install') }
    it { should contain_class('katello_devel::config') }
    it { should contain_class('katello_devel::database') }
  end

end
