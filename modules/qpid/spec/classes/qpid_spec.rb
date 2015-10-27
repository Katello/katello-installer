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

    it 'should install message store by default' do
      should contain_package('qpid-cpp-server-linearstore')
    end
  end

   context 'message store disabled' do
     let :params do
       {
         :server_store => false,
       }
     end

     it { should_not contain_package('qpid-cpp-server-linearstore') }
  end
end
