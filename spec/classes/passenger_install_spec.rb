require 'spec_helper'


describe 'passenger' do
  context 'on redhat' do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it 'should install passenger' do
      should contain_package('passenger').with({
        :ensure  => 'installed',
        :name    => 'mod_passenger',
        :require => 'Class[Apache::Install]',
        :before  => 'Class[Apache::Service]',
      })
    end
  end

  context 'on debian' do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end

    it 'should install passenger' do
      should contain_package('passenger').with({
        :ensure  => 'installed',
        :name    => 'libapache2-mod-passenger',
        :require => 'Class[Apache::Install]',
        :before  => 'Class[Apache::Service]',
      })
    end

    it 'should enable RequestHeaders' do
      should contain_exec('enable-headers').with({
        :command => '/usr/sbin/a2enmod headers',
        :creates => '/etc/apache2/mods-enabled/headers.load',
        :require => 'Class[Apache::Install]',
        :notify  => 'Class[Apache::Service]',
      })
    end
  end

  context 'on Amazon Linux' do
    let :facts do
      {
        :osfamily        => 'Linux',
        :operatingsystem => 'Amazon',
      }
    end

    it 'should install passenger' do
      should contain_package('passenger').with({
        :ensure  => 'installed',
        :name    => 'mod_passenger',
        :require => 'Class[Apache::Install]',
        :before  => 'Class[Apache::Service]',
      })
    end
  end

  context 'on unsupported Linux operatingsystem' do
    let :facts do
      {
        :hostname        => 'localhost',
        :osfamily        => 'Linux',
        :operatingsystem => 'Unsupported',
      }
    end

    it 'should fail' do
      expect { subject }.to raise_error(/#{facts[:hostname]}: This module does not support operatingsystem #{facts[:operatingsystem]}/)
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
      expect { subject }.to raise_error(/#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/)
    end
  end
end
