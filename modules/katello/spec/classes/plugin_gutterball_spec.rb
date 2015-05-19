require 'spec_helper'

describe 'katello::plugin::gutterball' do
  let :pre_condition do
      "class {['certs', 'foreman', 'katello']: }"
  end

  let :facts do
    {
      :concat_basedir             => '/tmp',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
      :osfamily                   => 'RedHat',
    }
  end

  it { should contain_class('certs::gutterball') }

  it 'should call the plugin' do
    should contain_foreman__plugin('gutterball')
  end

  it { should contain_class('gutterball') }
end
