require 'spec_helper'

describe 'qpid::router::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge(:concat_basedir => '/tmp', :processorcount => 2)
      end

      context 'without parameters' do
        let :pre_condition do
          'include qpid::router'
        end

        it 'should have header fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+header.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'container {',
            '    worker-threads: 2',
            '    container-name: foo.example.com',
            '}',
            'router {',
            '    mode: interior',
            '    router-id: foo.example.com',
            '}'
          ]
        end

        it 'should have footer fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+footer.conf').send(:parameters)[:content]
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
          should contain_concat('/etc/qpid-dispatch/qdrouterd.conf').with({
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
          content = catalogue.resource('concat::fragment', 'qdrouter+ssl_router-ssl.conf').send(:parameters)[:content]
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
             idle_timeout => 0,
           }
          '
        end

        it 'should have listener fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+listener_hub.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'listener {',
            '    addr: 0.0.0.0',
            '    port: 5672',
            '    sasl-mechanisms: ANONYMOUS',
            '    role: inter-router',
            '    ssl-profile: router-ssl',
            '    idle-timeout-seconds: 0',
            '}'
          ]
        end
      end

      context 'with connector' do
        let :pre_condition do
          'class {"qpid::router":}

           qpid::router::connector { "broker":
             addr         => "127.0.0.1",
             port         => "5672",
             role         => "on-demand",
             ssl_profile  => "router-ssl",
             idle_timeout => 0,
           }
          '
        end

        it 'should have connector fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+connector_broker.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'connector {',
            '    name: broker',
            '    addr: 127.0.0.1',
            '    port: 5672',
            '    sasl-mechanisms: ANONYMOUS',
            '    role: on-demand',
            '    ssl-profile: router-ssl',
            '    idle-timeout-seconds: 0',
            '}'
          ]
        end
      end

      context 'with symmetric link route pattern' do
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
          content = catalogue.resource('concat::fragment', 'qdrouter+link_route_pattern_broker-link.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'linkRoutePattern {',
            '    prefix: unicorn.',
            '    connector: broker',
            '}'
          ]
        end
      end

      context 'with asymmetric link route pattern' do
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
             direction => "in",
             prefix    => "unicorn.",
           }'
        end

        it 'should have link_route_pattern fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+link_route_pattern_broker-link.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'linkRoutePattern {',
            '    prefix: unicorn.',
            '    dir: in',
            '    connector: broker',
            '}'
          ]
        end
      end

      context 'with logging' do
        let :pre_condition do
          'class {"qpid::router":}

           qpid::router::log { "logging":
             module      => "DEFAULT",
             level       => "debug+",
             timestamp   => false,
             output      => "/var/log/qpid.log",
           }
          '
        end

        it 'should have log fragment' do
          content = catalogue.resource('concat::fragment', 'qdrouter+log_logging.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'log {',
            '    module: DEFAULT',
            '    enabled: debug+',
            '    timestamp: false',
            '    output: /var/log/qpid.log',
            '}'
          ]
        end
      end
    end
  end
end
