require 'spec_helper'

describe 'pulp::install' do
  let :default_facts do
    on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
  end

  describe "with enable_parent_node" do
    let :facts do
      default_facts
    end

    let :pre_condition do
      "class {'pulp': enable_parent_node => true}"
    end

    it { should contain_package('pulp-nodes-parent').with_ensure('installed') }
  end

  describe "with enable_ostree" do
    let :facts do
      default_facts
    end

    let :pre_condition do
      "class {'pulp': enable_ostree => true}"
    end

    it { should contain_package('ostree').with_ensure('present') }
    it { should contain_package('pulp-ostree-plugins').with_ensure('installed') }
  end
end
