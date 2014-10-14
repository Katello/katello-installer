require 'spec_helper'

describe 'candlepin' do

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

    it { should contain_class('candlepin::install') }
    it { should contain_class('candlepin::config') }
    it { should contain_class('candlepin::service') }
  end

end
