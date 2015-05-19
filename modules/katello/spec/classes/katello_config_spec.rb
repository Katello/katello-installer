require 'spec_helper'

describe 'katello::config' do
  let :facts do
    {
      :concat_basedir         => '/tmp',
      :interfaces             => '',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.5',
      :fqdn                   => 'host.example.org',
    }
  end

  context 'default config settings' do
    let(:pre_condition) do
      [
        'include foreman',
        'include certs',
        'class {"katello":' \
          'post_sync_token => test_token,' \
          'oauth_secret   => secret' \
        '}'
      ]
    end

    it 'should NOT set the cdn-ssl-version' do
      should_not contain_file('/etc/foreman/plugins/katello.yaml').
        with_content(/cdn_ssl_version/)
    end

    it 'should generate correct katello.yaml' do
      should contain_file('/etc/foreman/plugins/katello.yaml')
      content = catalogue.resource('file', '/etc/foreman/plugins/katello.yaml').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
        'common:',
        '  rest_client_timeout: 120',
        '  post_sync_url: https://localhost/katello/api/v2/repositories/sync_complete?token=test_token',
        '  candlepin:',
        '    url: https://localhost:8443/candlepin',
        '    oauth_key: katello',
        '    oauth_secret: secret',
        '  pulp:',
        "    url: https://#{facts[:fqdn]}/pulp/api/v2/",
        '    oauth_key: katello',
        '    oauth_secret: secret',
        '  qpid:',
        "    url: amqp:ssl:#{facts[:fqdn]}:5671",
        '    subscriptions_queue_address: katello_event_queue'
      ]
    end
  end

  context 'when http proxy parameters are specified' do
    let(:pre_condition) do
      [
        'include foreman',
        'include certs',
        'class {"katello":' \
          'post_sync_token => "test_token",' \
          'oauth_secret    => "secret",' \
          'proxy_url       => "http://myproxy.org",' \
          'proxy_port      => 8888,' \
          'proxy_username  => "admin",' \
          'proxy_password  => "secret_password"' \
        '}'
      ]
    end

    it 'should generate correct katello.yaml' do
      should contain_file('/etc/foreman/plugins/katello.yaml')
      content = catalogue.resource('file', '/etc/foreman/plugins/katello.yaml').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
        'common:',
        '  rest_client_timeout: 120',
        '  post_sync_url: https://localhost/katello/api/v2/repositories/sync_complete?token=test_token',
        '  candlepin:',
        '    url: https://localhost:8443/candlepin',
        '    oauth_key: katello',
        '    oauth_secret: secret',
        '  pulp:',
        "    url: https://#{facts[:fqdn]}/pulp/api/v2/",
        '    oauth_key: katello',
        '    oauth_secret: secret',
        '  qpid:',
        "    url: amqp:ssl:#{facts[:fqdn]}:5671",
        '    subscriptions_queue_address: katello_event_queue',
        '  cdn_proxy:',
        '    host: http://myproxy.org',
        '    port: 8888',
        '    user: admin',
        '    password: secret_password'
      ]
    end
  end
end
