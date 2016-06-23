require 'spec_helper'

describe 'trusted_ca::ca', :type => :define do
  let(:title) { 'mycert' }
  let(:pre_condition) { 'include trusted_ca' }
  let(:params) { { :source => 'puppet:///data/mycert.crt' } }

  context 'validations' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '6' } }

    context 'bad source' do
      let(:params) { { :source => 'foo' } }
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end

    context 'bad content' do
      let(:params) { { :source => Nil, :content => 'foo' } }
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end

    context 'specifying both source and content' do
      let(:params) { { :content => 'foo' } }
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end

    context 'specifying neither source nor content' do
      let(:params) { { :content => Nil, :source => Nil } }
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end

    context 'not including trusted_ca' do
      let(:pre_condition) {}
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end
  end

  context 'on RedHat' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '6' } }

    context 'default' do
      it { should contain_file('/etc/pki/ca-trust/source/anchors/mycert.crt').with(
        :source => 'puppet:///data/mycert.crt',
        :notify => "Exec[validate /etc/pki/ca-trust/source/anchors/mycert.crt]"
      ) }
    end

  end

  context 'on Ubuntu' do
    let(:facts) { { :osfamily => 'Debian', :operatingsystemrelease => '12.04' } }

    context 'default' do
      it { should contain_file('/usr/local/share/ca-certificates/mycert.crt').with(
        :source => 'puppet:///data/mycert.crt',
        :notify => "Exec[validate /usr/local/share/ca-certificates/mycert.crt]"
      ) }
    end
  end

  context 'on Suse SLES' do
    let(:facts) { { :osfamily => 'Suse', :operatingsystem => 'SLES' } }
    let(:params) { { :source => 'puppet:///data/mycert.pem' } }

    context 'default' do
      it { should contain_file('/etc/ssl/certs/mycert.pem').with(
        :source => 'puppet:///data/mycert.pem',
        :notify => "Exec[validate /etc/ssl/certs/mycert.pem]"
      ) }
    end
  end

  context 'on Suse OpenSuSE' do
    let(:facts) { { :osfamily => 'Suse', :operatingsystem => 'OpenSuSE' } }
    let(:params) { { :source => 'puppet:///data/mycert.pem' } }

    context 'default' do
      it { should contain_file('/etc/pki/trust/anchors/mycert.pem').with(
        :source => 'puppet:///data/mycert.pem',
        :notify => "Exec[validate /etc/pki/trust/anchors/mycert.pem]"
      ) }
    end
  end

end
