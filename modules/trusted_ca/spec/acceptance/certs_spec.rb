require 'spec_helper_acceptance'

describe 'trusted_ca' do

  context 'failure before cert' do

    # Set up site first, verify things don't work
    it 'should set up apache for testing' do
      pp = <<-EOS
      include java
      include apache
      apache::vhost { 'trusted_ca':
        docroot    => '/tmp',
        port       => 443,
        servername => $::fqdn,
        ssl        => true,
        ssl_cert   => '/etc/ssl-secure/test.crt',
        ssl_key    => '/etc/ssl-secure/test.key',
      }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe command("/usr/bin/curl https://#{fact('hostname')}.example.com:443") do
      its(:exit_status) { should eq 60 }
    end

    describe command("cd /root && /usr/bin/java SSLPoke #{fact('hostname')}.example.com 443") do
      its(:exit_status) { should eq 1 }
    end

  end

  context 'success after cert' do

    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'trusted_ca': }
      trusted_ca::ca { 'test': source => '/etc/ssl-secure/test.crt' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('ca-certificates') do
      it { is_expected.to be_installed }
    end

    describe command("/usr/bin/curl https://#{fact('hostname')}.example.com:443") do
      its(:exit_status) { should eq 0 }
    end

    describe command("cd /root && /usr/bin/java SSLPoke #{fact('hostname')}.example.com 443") do
      its(:exit_status) { should eq 0 }
    end

  end
end
