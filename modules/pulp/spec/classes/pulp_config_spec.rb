require 'spec_helper'


describe 'pulp::config' do
  let :default_facts do
    on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :processorcount => 3,
                                             :root_home => '/root')
  end

  context 'with no parameters' do
    let :pre_condition do
      "class {'pulp':}"
    end

    let :facts do
      default_facts
    end

    it "should configure pulp_workers" do
      should contain_file('/etc/default/pulp_workers').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    end

    describe 'with processor count less than 8' do

      it "should set the PULP_CONCURRENCY to the processor count" do
        should contain_file('/etc/default/pulp_workers').with_content(/^PULP_CONCURRENCY=3$/)
      end

    end

    describe 'with processor count more than 8' do
      let :facts do
        default_facts.merge({
          :processorcount => 12
        })
      end

      it "should set the PULP_CONCURRENCY to 8" do
        should contain_file('/etc/default/pulp_workers').with_content(/^PULP_CONCURRENCY=8$/)
      end
    end

    it 'should configure server.conf' do
      should contain_file('/etc/pulp/server.conf').
        with_content(/^topic_exchange: 'amq.topic'$/)
    end
  end

  context 'with database auth parameters on unsupported mongo' do
    let :pre_condition do
      "class {'pulp':
        db_username => 'rspec',
        db_password => 'rsp3c4l1f3',
       }"
    end

    let :facts do
      default_facts
    end

    it "should not configure auth" do
      should contain_file('/etc/pulp/server.conf').
        without_content(/^username: rspec$/).
        without_content(/^password: rsp3c4l1f3$/)
    end
  end

  context 'with database auth parameters on supported mongo' do
    let :pre_condition do
      "class {'pulp':
        db_username => 'rspec',
        db_password => 'rsp3c4l1f3',
       }"
    end

    let :facts do
      default_facts.merge(:mongodb_version => '2.6.1')
    end

    it "should configure auth" do
      should contain_file('/etc/pulp/server.conf').
        with_content(/^username: rspec$/).
        with_content(/^password: rsp3c4l1f3$/)
    end
  end

  context "with proxy configuration" do
    let :pre_condition do
      "class {'pulp':
        enable_rpm     => true,
        proxy_url      => 'http://fake.com',
        proxy_port     => 7777,
        proxy_username => 'al',
        proxy_password => 'beproxyin'
      }"
    end

    let :facts do
      default_facts
    end

    it "should produce valid json" do
      should contain_file("/etc/pulp/server/plugins.conf.d/yum_importer.json").with_content(
        /"proxy_host": "http:\/\/fake.com",/
      ).with_content(
        /"proxy_port": 7777,/
      ).with_content(
        /"proxy_username": "al",/
      ).with_content(
        /"proxy_password": "beproxyin"/
      )
    end

  end
end
