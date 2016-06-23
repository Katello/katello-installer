require 'spec_helper'

describe 'katello::install' do
  let :facts do
    {
      :concat_basedir         => '/tmp',
      :interfaces             => '',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.5',
      :fqdn                   => 'host.example.org',
    }
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
