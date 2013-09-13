require 'spec_helper'


describe 'passenger' do
  context 'on redhat' do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it 'should include redhat install' do
      should include_class('passenger::install::redhat')
    end
  end

  context 'on debian' do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end

    it 'should include debian install' do
      should include_class('passenger::install::debian')
    end
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        :hostname => 'localhost',
        :osfamily => 'Unsupported',
      }
    end

    it 'should fail' do
      expect { subject }.to raise_error(/#{facts[:hostname]}: This module does not support operatingsystem #{facts[:osfamily]}/)
    end
  end
end
