require 'spec_helper'

describe 'qpid::client::config' do
  context 'on redhat' do
    let :facts do
      {
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6.4',
        :osfamily                   => 'RedHat',
        :fqdn                       => 'host.example.com',
        :processorcount             => 2,
      }
    end

    context 'without parameters' do
      let :pre_condition do
        'class {"qpid::router": }'
      end

      it 'should have header fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+header.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'container {',
          '    worker-threads: 2',
          '    container-name: host.example.com',
          '}',
          'router {',
          '    mode: interior',
          '    router-id: host.example.com',
          '}'
        ]
      end

      it 'should have footer fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+footer.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'fixed-address {',
          '    prefix: /closest',
          '    fanout: single',
          '    bias: closest',
          '}',
          'fixed-address {',
          '    prefix: /unicast',
          '    fanout: single',
          '    bias: closest',
          '}',
          'fixed-address {',
          '    prefix: /exclusive',
          '    fanout: single',
          '    bias: closest',
          '}',
          'fixed-address {',
          '    prefix: /multicast',
          '    fanout: multiple',
          '}',
          'fixed-address {',
          '    prefix: /broadcast',
          '    fanout: multiple',
          '}',
          'fixed-address {',
          '    prefix: /',
          '    fanout: multiple',
          '}'
        ]
      end

      it 'should configure qdrouter.conf' do
        should contain_file('/etc/qpid-dispatch/qdrouterd.conf').with({
          'source'  => %r{/concat/output/qdrouter.out$},
          'require' => 'Concat_build[qdrouter]',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      end
    end

    context 'with ssl profile' do
      let :pre_condition do
        'class {"qpid::router":}

         qpid::router::ssl_profile { "router-ssl":
           ca      => "/some/where/ca.pem",
           cert    => "/some/where/cert.pem",
           key     => "/some/where/key.pem",
         }
        '
      end

      it 'should have ssl fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+ssl_router-ssl.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'ssl-profile {',
          '    name: router-ssl',
          '    cert-db: /some/where/ca.pem',
          '    cert-file: /some/where/cert.pem',
          '    key-file: /some/where/key.pem',
          '}'
        ]
      end
    end

    context 'with listener' do
      let :pre_condition do
        'class {"qpid::router":}

         qpid::router::listener { "hub":
           role        => "inter-router",
           ssl_profile => "router-ssl",
         }
        '
      end

      it 'should have listener fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+listener_hub.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'listener {',
          '    addr: 0.0.0.0',
          '    port: 5672',
          '    sasl-mechanisms: ANONYMOUS',
          '    role: inter-router',
          '    ssl-profile: router-ssl',
          '}'
        ]
      end
    end

    context 'with connector' do
      let :pre_condition do
        'class {"qpid::router":}

         qpid::router::connector { "broker":
           addr        => "127.0.0.1",
           port        => "5672",
           role        => "on-demand",
           ssl_profile => "router-ssl",
         }
        '
      end

      it 'should have connector fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+connector_broker.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'connector {',
          '    name: broker',
          '    addr: 127.0.0.1',
          '    port: 5672',
          '    sasl-mechanisms: ANONYMOUS',
          '    role: on-demand',
          '    ssl-profile: router-ssl',
          '}'
        ]
      end
    end

    context 'with link route pattern' do
      let :pre_condition do
        'class {"qpid::router":}

         qpid::router::connector { "broker":
           addr        => "127.0.0.1",
           port        => "5672",
           role        => "on-demand",
           ssl_profile => "router-ssl",
         }

         qpid::router::link_route_pattern { "broker-link":
           connector => "broker",
           prefix    => "unicorn.",
         }'
      end

      it 'should have link_route_pattern fragment' do
        content = subject.resource('concat_fragment', 'qdrouter+link_route_pattern_broker-link.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'linkRoutePattern {',
          '    prefix: unicorn.',
          '    connector: broker',
          '}'
        ]
      end
    end
  end
end
