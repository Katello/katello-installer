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

end
