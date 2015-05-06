require 'spec_helper'

describe 'capsule' do

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

    let(:pre_condition) do
      ['include certs']
    end

    it { should contain_class('capsule::install') }
  end

  context 'with pulp' do
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
        :pulp              => true,
        :pulp_oauth_secret => 'mysecret',
        :qpid_router       => false
      }
    end

    let(:pre_condition) do
      ['include certs']
    end

    it { should contain_class('crane').with( {'key' => '/etc/pki/katello/private/katello-apache.key',
                                              'cert' => '/etc/pki/katello/certs/katello-apache.crt'} ) }
  end

end
