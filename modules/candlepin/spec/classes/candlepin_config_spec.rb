require 'spec_helper'

describe 'candlepin::config' do

  let :facts do
    {
      :concat_basedir         => '/tmp',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6.4',
      :osfamily               => 'RedHat',
      :fqdn                   => 'localhost',
    }
  end

  describe 'without parameters' do
    let :pre_condition do
      "class {'candlepin':}"
    end

    it "should setup the config" do
      should contain_concat__fragment('General Config').
        with_content(/^candlepin.environment_content_filtering=true$/).
        with_content(/^candlepin.auth.basic.enable=true$/).
        with_content(/^candlepin.auth.trusted.enable=false$/).
        with_content(/^candlepin.auth.oauth.enable=true$/).
        with_content(/^candlepin.auth.oauth.consumer.candlepin.secret=candlepin$/).
        with_content(/^candlepin.ca_key=\/etc\/candlepin\/certs\/candlepin-ca.key$/).
        with_content(/^candlepin.ca_cert=\/etc\/candlepin\/certs\/candlepin-ca.crt$/).
        with_content(/^candlepin.crl.file=\/var\/lib\/candlepin\/candlepin-crl.crl$/).
        with({})
    end
  end

  describe 'with custom adapter module' do
    cp_version = '0.9.26'

    let :pre_condition do
      "class {'candlepin':
        adapter_module => 'my.custom.adapter_module',
        version => cp_version,
      }"
    end

    it 'should set a custom module' do
      should contain_concat__fragment('General Config').
        with_content(/module.config.adapter_module=my.custom.adapter_module/)
    end
  end

  context 'with amqp enabled' do
    describe 'and default configuration' do
      let :pre_condition do
        "class {'candlepin':
          amq_enable => true,
          amqp_truststore_password => 'password',
          amqp_keystore_password => 'password',
        }"
      end

      it "should setup the amqp config" do
        should contain_concat__fragment('General Config').
          with_content(/^candlepin.amqp.enable=true$/).
          with_content(/^candlepin.amqp.connect=tcp:\/\/localhost:5671\?ssl='true'&ssl_cert_alias='amqp-client'$/).
          with_content(/^candlepin.amqp.keystore_password=password$/).
          with_content(/^candlepin.amqp.keystore=\/etc\/candlepin\/certs\/amqp\/candlepin.jks$/).
          with_content(/^candlepin.amqp.truststore_password=password$/).
          with_content(/^candlepin.amqp.truststore=\/etc\/candlepin\/certs\/amqp\/candlepin.truststore$/).
          with({})
      end
    end

    describe 'specifying truststore and keystore locations' do
      let :pre_condition do
        "class {'candlepin':
          amq_enable               => true,
          amqp_truststore_password => 'password',
          amqp_keystore_password   => 'password',
          amqp_keystore            => '/etc/pki/my.jks',
          amqp_truststore          => '/etc/pki/my.truststore',
        }"
      end

      it "should setup the amqp config" do
        should contain_concat__fragment('General Config').
          with_content(/^candlepin.amqp.enable=true$/).
          with_content(/^candlepin.amqp.connect=tcp:\/\/localhost:5671\?ssl='true'&ssl_cert_alias='amqp-client'$/).
          with_content(/^candlepin.amqp.keystore_password=password$/).
          with_content(/^candlepin.amqp.keystore=\/etc\/pki\/my.jks$/).
          with_content(/^candlepin.amqp.truststore_password=password$/).
          with_content(/^candlepin.amqp.truststore=\/etc\/pki\/my.truststore$/).
          with({})
      end
    end
  end

  describe 'with ssl_port' do
    let :pre_condition do
      "class {'candlepin':
        ssl_port => 9070,
      }"
    end

    it "should setup the tomcat config file" do
      should contain_file('/etc/tomcat6/server.xml').
        with_content(/^    <Connector port="9070" protocol="HTTP\/1.1" SSLEnabled="true"/).
        with({})
    end
  end
end
