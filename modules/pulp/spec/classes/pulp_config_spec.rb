require 'spec_helper'


describe 'pulp::config' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6.4',
      :osfamily                   => 'RedHat',
      :processorcount             => 3
    }
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
  end

end
