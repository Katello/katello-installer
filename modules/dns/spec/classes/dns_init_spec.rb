require 'spec_helper'

describe 'dns' do

  describe 'on RedHat with no custom parameters' do

    let(:facts) do
      {
         :clientcert => 'puppetmaster.example.com',
         :concat_basedir => '/doesnotexist',
         :fqdn => 'puppetmaster.example.com',
         :osfamily => 'RedHat',
      }
    end

    describe 'with no custom parameters' do
      it { should contain_class('dns::install') }
      it { should contain_class('dns::config') }
      it { should contain_class('dns::service') }

      it { should contain_package('bind').with_ensure('present') }

      it { should contain_file('/etc/named/options.conf').
                  with_content(%r{listen-on-v6 { any; };}) }
      it { should contain_file('/var/named/dynamic').with_ensure('directory') }
      it { should contain_file('/etc/named.conf').
                  with_content(%r{include "/etc/rndc.key"}).
                  with_content(%r{include "/etc/named.rfc1912.zones"}).
                  with_content(%r{include "/etc/zones.conf"}).
                  with_content(%r{include "/etc/named/options.conf"}) }
      it { should contain_exec('create-rndc.key').
                  with_command("/usr/sbin/rndc-confgen -r /dev/urandom -a -c /etc/rndc.key") }

      it { should contain_service('named').with_ensure('running').with_enable(true) }
    end

    describe 'with ipv6 disabled' do
      let(:params) { {:listen_on_v6 => 'none'} }
      it { should contain_file('/etc/named/options.conf').
                  with_content(%r{listen-on-v6 { none; };}) }
    end
  end

  describe 'on FreeBSD with no custom parameters' do

    let(:facts) do
      {
         :clientcert => 'puppetmaster.example.com',
         :concat_basedir => '/doesnotexist',
         :fqdn => 'puppetmaster.example.com',
         :osfamily => 'FreeBSD',
      }
    end

    describe 'with no custom parameters' do
      it { should contain_class('dns::install') }
      it { should contain_class('dns::config') }
      it { should contain_class('dns::service') }

      it { should contain_package('bind910').with_ensure('present') }

      it { should contain_file('/usr/local/etc/namedb/options.conf').
                  with_content(%r{listen-on-v6 { any; };}) }
      it { should contain_file('/usr/local/etc/namedb/dynamic').with_ensure('directory') }
      it { should contain_file('/usr/local/etc/namedb/named.conf').
                  with_content(%r{include "/usr/local/etc/namedb/rndc.key"}).
                  with_content(%r{include "/usr/local/etc/namedb/zones.conf"}).
                  with_content(%r{include "/usr/local/etc/namedb/options.conf"}) }
      it { should contain_exec('create-rndc.key').
                  with_command("/usr/local/sbin/rndc-confgen -r /dev/urandom -a -c /usr/local/etc/namedb/rndc.key") }

      it { should contain_service('named').with_ensure('running').with_enable(true) }
    end
  end
end
