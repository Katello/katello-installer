require 'spec_helper'

describe 'pulp::child::fragment' do
  let(:title) { 'test_name' }

  let :pre_condition do
    "include pulp
      class {'pulp::child':
        parent_fqdn => 'mamma-pulp'
      }"
  end

  context 'on redhat' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
    end

    context 'with ssl_content parameter' do
      let :params do
        { :ssl_content => "some_string" }
      end

      it do
        should contain_concat__fragment("test_name").with_content(/some_string/)
      end
    end

  end
end
