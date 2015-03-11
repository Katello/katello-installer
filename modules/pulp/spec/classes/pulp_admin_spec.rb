require 'spec_helper'

describe 'pulp::admin' do
  context 'on RedHat' do
    context 'install class without parameters' do
      it { should contain_class('pulp::admin::install') }
      it { should contain_class('pulp::admin::config') }
      it { should contain_class('pulp::admin::params') }

      it { should contain_package('pulp-admin-client').with_ensure('installed') }

      it 'should set admin.conf file' do
        should contain_file('/etc/pulp/admin/admin.conf').
          with_content(/^\[server\]$/).
          with_content(/^host: localhost$/).
          with_content(/^port: 443$/).
          with_content(/^api_prefix: \/pulp\/api$/).
          with_content(/^verify_ssl: true$/).
          with_content(/^ca_path: \/etc\/pki\/tls\/certs\/ca-bundle.crt$/).
          with_content(/^upload_chunk_size: 1048576$/).
          with_content(/^\[client\]$/).
          with_content(/^role: admin$/).
          with_content(/^\[filesystem\]$/).
          with_content(/^extensions_dir: \/usr\/lib\/pulp\/admin\/extensions$/).
          with_content(/^id_cert_dir: ~\/.pulp$/).
          with_content(/^id_cert_filename: user-cert.pem$/).
          with_content(/^upload_working_dir: ~\/.pulp\/uploads$/).
          with_content(/^\[logging\]$/).
          with_content(/^filename: ~\/.pulp\/admin.log$/).
          with_content(/^call_log_filename: ~\/.pulp\/server_calls.log$/).
          with_content(/^\[output\]$/).
          with_content(/^poll_frequency_in_seconds: 1$/).
          with_content(/^enable_color: true$/).
          with_content(/^wrap_to_terminal: false$/).
          with_content(/^wrap_width: 80$/).
          with_ensure('file')
      end
    end

    context 'install with puppet param' do
      let(:params) do {
          'puppet' => true,
        } end

      it { should contain_package('pulp-puppet-admin-extensions').with_ensure('installed') }

      it 'should set puppet.conf file' do
        should contain_file('/etc/pulp/admin/conf.d/puppet.conf').
          with_content(/^\[puppet\]$/).
          with_content(/^upload_working_dir = ~\/.pulp\/puppet-uploads$/).
          with_content(/^upload_chunk_size = 1048576$/).
          with_ensure('file')
      end

    end

    context 'install with docker param' do
      let(:params) do {
          'docker' => true,
        } end

      it { should contain_package('pulp-docker-admin-extensions').with_ensure('installed') }
    end

    context 'install with puppet nodes' do
      let(:params) do {
          'nodes' => true,
        } end

      it { should contain_package('pulp-nodes-admin-extensions').with_ensure('installed') }
    end

    context 'install with python param' do
      let(:params) do {
          'python' => true,
        } end

      it { should contain_package('pulp-python-admin-extensions').with_ensure('installed') }
    end

    context 'install with rpm param' do
      let(:params) do {
          'rpm' => true,
        } end

      it { should contain_package('pulp-rpm-admin-extensions').with_ensure('installed') }
    end

    context 'install with params' do
      let(:params) do {
          'host' => 'pulp.company.net',
          'verify_ssl' => false,
        } end

      it 'should set the defaults file' do
        should contain_file('/etc/pulp/admin/admin.conf').
          with_content(/^\[server\]$/).
          with_content(/^host: pulp.company.net$/).
          with_content(/^verify_ssl: false$/).
          with_ensure('file')
      end
    end
  end
end
