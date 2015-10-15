require 'spec_helper'

describe 'qpid' do

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

    it { should contain_class('qpid::install') }
    it { should contain_class('qpid::config') }
    it { should contain_class('qpid::service') }
  end

end
