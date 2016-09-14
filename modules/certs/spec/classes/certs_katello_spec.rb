require 'spec_helper'

describe 'certs::katello' do
  let :facts do
    on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :puppetversion => Puppet.version)
  end

  context 'with parameters' do
    let :pre_condition do
      "class {'certs': pki_dir => '/tmp', server_ca_name => 'server_ca', default_ca_name => 'default_ca'}"
    end

    describe 'with katello certs set' do
      # source format should be -> "${certs::pki_dir}/certs/${server_ca_name}.crt"
      it { should contain_trusted_ca__ca('katello_server-host-cert').with({ :source => "/tmp/certs/server_ca.crt" }) }
    end
  end
end
