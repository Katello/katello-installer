require 'spec_helper'

describe 'qpid' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge(:concat_basedir => '/tmp')
      end

      it { should contain_class('qpid::install') }
      it { should contain_class('qpid::config') }
      it { should contain_class('qpid::service') }

      it 'should install message store by default' do
        should contain_package('qpid-cpp-server-linearstore')
      end

      context 'message store disabled' do
        let :params do
          {
            :server_store => false,
          }
        end

        it { should_not contain_package('qpid-cpp-server-linearstore') }
      end
    end
  end
end
