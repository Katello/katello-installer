require 'spec_helper'

describe 'capsule' do

 context 'on redhat' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6',
        :operatingsystemmajrelease  => '6',
        :osfamily                   => 'RedHat',
      }
    end

    it { should contain_package('katello-debug') }
    it { should contain_package('katello-client-bootstrap') }
  end

  context 'with pulp' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6',
        :operatingsystemmajrelease  => '6',
        :osfamily                   => 'RedHat',
      }
    end

    let(:params) do
      {
        :pulp_oauth_secret => 'mysecret',
        :qpid_router       => false
      }
    end

    let(:pre_condition) do
      "class {'foreman_proxy::plugin::pulp': pulpnode_enabled => true}
       class {'apache': apache_version => '2.4'}"
    end

    it { should contain_class('crane').with( {'key' => '/etc/pki/katello/private/katello-apache.key',
                                              'cert' => '/etc/pki/katello/certs/katello-apache.crt'} ) }

    it { should contain_pulp__apache__fragment('gpg_key_proxy').with({
           :ssl_content => %r{ProxyPass /katello/api/repositories/}} ) }
  end

end
