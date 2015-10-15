require 'spec_helper'

describe 'pulp::install' do
  let :default_facts do
    {
      :concat_basedir             => '/tmp',
      :interfaces                 => '',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6.4',
      :osfamily                   => 'RedHat',
      :fqdn                       => 'pulp.compony.net',
      :hostname                   => 'pulp',
    }
  end

  describe "with parent" do
    let :facts do
      default_facts
    end

    let :pre_condition do
      "class {'pulp': parent => true}"
    end
    
    it { should contain_package('pulp-nodes-parent').with_ensure('installed') }
  end
end
