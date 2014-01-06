require 'spec_helper'

describe 'dns' do

  let(:facts) do
    {
      :osfamily   => 'RedHat',
      :fqdn => 'puppetmaster.example.com',
      :clientcert => 'puppetmaster.example.com',
    }
  end

  describe 'with no custom parameters' do
    it { should include_class('dns::install') }
    it { should include_class('dns::config') }
    it { should include_class('dns::service') }

    it { should contain_package('dns').with_ensure('present').with_name('bind') }

    it { should contain_file('/etc/named/options.conf').
          with_content(%r{listen-on-v6 { any; };})}
    it { should contain_file('/var/named/dynamic').with_ensure('directory') }
    it { should contain_file('/etc/named.conf').
          with_content(%r{include "/etc/rndc.key"}).
          with_content(%r{include "/etc/named.rfc1912.zones"}).
          with_content(%r{include "/etc/zones.conf"}).
          with_content(%r{include "/etc/named/options.conf"})}
    it { should contain_exec('create-rndc.key').
          with_command("/usr/sbin/rndc-confgen -r /dev/urandom -a -c /etc/rndc.key") }

    it { should contain_service('named').with_ensure('running').with_enable(true) }
  end

  describe 'with ipv6 disabled' do
    let(:params) { {:listen_on_v6 => 'none'} }
    it { should contain_file('/etc/named/options.conf').
          with_content(%r{listen-on-v6 { none; };})}
  end
end
