require 'spec_helper'

describe 'katello::config' do
  let :facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.5',
    }
  end

  context 'default config settings' do
    let(:pre_condition) do
       ['include foreman','include certs']
    end

    it 'should NOT set the cdn-ssl-version' do
      should_not contain_file('/etc/foreman/plugins/katello.yaml').
        with_content(/cdn_ssl_version/)
    end
  end
end
