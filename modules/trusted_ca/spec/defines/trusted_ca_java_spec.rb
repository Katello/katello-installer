require 'spec_helper'

describe 'trusted_ca::java', :type => :define do
  let(:title) { 'mycert' }
  let(:pre_condition) { 'include trusted_ca' }
  let(:params) { {
    :source => 'puppet:///data/mycert.crt',
    :java_keystore => '/etc/alternatives/jre_1.7.0/lib/security/cacerts'
  } }

  let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '6' } }

  context 'validations' do

    context 'bad source' do
      let(:params) { { :source => 'foo' } }
      it { expect { should create_define('trusted_ca::java') }.to raise_error }
    end

    context 'bad content' do
      let(:params) { { :source => Nil, :content => 'foo' } }
      it { expect { should create_define('trusted_ca::java') }.to raise_error }
    end

    context 'specifying both source and content' do
      let(:params) { { :content => 'foo' } }
      it { expect { should create_define('trusted_ca::java') }.to raise_error }
    end

    context 'specifying neither source nor content' do
      let(:params) { { :content => Nil, :source => Nil } }
      it { expect { should create_define('trusted_ca::java') }.to raise_error }
    end

    context 'not including trusted_ca' do
      let(:pre_condition) {}
      it { expect { should create_define('trusted_ca::java') }.to raise_error }
    end
  end

  it { should contain_file('/tmp/mycert-trustedca') }
  it { should contain_exec('import /tmp/mycert-trustedca to jks /etc/alternatives/jre_1.7.0/lib/security/cacerts').with(
    :command => 'keytool -import -noprompt -trustcacerts -alias mycert -file /tmp/mycert-trustedca -keystore /etc/alternatives/jre_1.7.0/lib/security/cacerts -storepass changeit'
  )}

end
