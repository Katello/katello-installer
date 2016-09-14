require 'spec_helper'

describe 'katello::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
      end

      describe 'with enable_ostree == false' do
        let(:pre_condition) do
          ['include foreman',
           'include certs',
           "class {'katello':
              enable_ostree => false,
           }"
          ]
        end

        it { should_not contain_package("tfm-rubygem-katello_ostree")}
      end

      describe 'with enable_ostree == true' do
        let(:pre_condition) do
          ['include foreman',
           'include certs',
           "class {'katello':
              enable_ostree => true,
           }"
          ]
        end
        it { should contain_package("tfm-rubygem-katello_ostree").with_ensure('installed').
                                                                  with_notify(["Service[foreman-tasks]", "Service[httpd]"]) }
      end
    end
  end
end
