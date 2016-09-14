require 'spec_helper'

describe 'pulp::apache::fragment' do
  let(:title) { 'fragment_title' }

  context 'on redhat' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
    end

    context 'with ssl_content parameter' do
      let :params do
        { :ssl_content => "some_string" }
      end

      it do
        should contain_concat__fragment("fragment_title").with_content('some_string')
      end
    end

  end
end
