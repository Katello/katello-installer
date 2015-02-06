require 'spec_helper'

describe 'qpid::client::config' do
  context 'on redhat' do
    let :facts do
      {
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6.4',
        :osfamily                   => 'RedHat',
      }
    end

    context 'without parameters' do
      let :pre_condition do
        'class {"qpid::client": }'
      end

      it 'should create configuration file' do
        content = subject.resource('file', '/etc/qpid/qpidc.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          'log-enable=error+',
        ]
      end

      context 'with ssl options' do
        let :pre_condition do
          'class {"qpid::client":
            ssl                     => true,
            ssl_port                => 5671,
            ssl_cert_db             => "/etc/pki/katello/nssdb",
            ssl_cert_password_file  => "/etc/pki/katello/nssdb/nss_db_password-file",
            ssl_cert_name           => "broker",
          }'
        end

        it 'should create configuration file' do
          content = subject.resource('file', '/etc/qpid/qpidc.conf').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            'log-enable=error+',
            'ssl-port=5671',
            'ssl-cert-db=/etc/pki/katello/nssdb',
            'ssl-cert-password-file=/etc/pki/katello/nssdb/nss_db_password-file',
            'ssl-cert-name=broker'
          ]
        end
      end
    end
  end
end
