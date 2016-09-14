require 'spec_helper'

describe 'katello::config' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts.merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
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
          ':katello:',
          '  :rest_client_timeout: 3600',
          '  :post_sync_url: https://foo.example.com/katello/api/v2/repositories/sync_complete?token=test_token',
          '  :candlepin:',
          '    :url: https://foo.example.com:8443/candlepin',
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '  :pulp:',
          "    :url: https://#{facts[:fqdn]}/pulp/api/v2/",
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '  :qpid:',
          "    :url: amqp:ssl:#{facts[:fqdn]}:5671",
          '    :subscriptions_queue_address: katello_event_queue'
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
          ':katello:',
          '  :rest_client_timeout: 3600',
          '  :post_sync_url: https://foo.example.com/katello/api/v2/repositories/sync_complete?token=test_token',
          '  :candlepin:',
          '    :url: https://foo.example.com:8443/candlepin',
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '  :pulp:',
          "    :url: https://#{facts[:fqdn]}/pulp/api/v2/",
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '  :qpid:',
          "    :url: amqp:ssl:#{facts[:fqdn]}:5671",
          '    :subscriptions_queue_address: katello_event_queue',
          '  :cdn_proxy:',
          '    :host: http://myproxy.org',
          '    :port: 8888',
          '    :user: admin',
          '    :password: secret_password'
        ]
      end
    end
  end
end
