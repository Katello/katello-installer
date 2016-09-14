require 'spec_helper'

describe 'pulp::consumer' do
  context 'on RedHat' do
    context 'install class without parameters' do
      let :facts do
        on_supported_os['redhat-7-x86_64'].merge(:concat_basedir => '/tmp', :mongodb_version => '2.4.14', :root_home => '/root')
      end

      it { should contain_class('pulp::consumer::install') }
      it { should contain_class('pulp::consumer::config') }
      it { should contain_class('pulp::consumer::params') }
      it { should contain_class('pulp::consumer::service') }

      it { should contain_package('pulp-consumer-client').with_ensure('installed') }
      it { should contain_package('pulp-rpm-consumer-extensions').with_ensure('installed') }
      it { should contain_package('pulp-rpm-yumplugins').with_ensure('installed') }
      it { should contain_package('pulp-agent').with_ensure('installed') }
      it { should contain_package('pulp-rpm-handlers').with_ensure('installed') }

      it 'should set consumer.conf file' do
        should contain_file('/etc/pulp/consumer/consumer.conf').
          with_content(/^\[server\]$/).
          with_content(/^host: foo.example.com$/).
          with_content(/^port: 443$/).
          with_content(/^api_prefix: \/pulp\/api$/).
          with_content(/^rsa_pub: \/etc\/pki\/pulp\/consumer\/server\/rsa_pub.key$/).
          with_content(/^verify_ssl: true$/).
          with_content(/^ca_path: \/etc\/pki\/tls\/certs\/ca-bundle.crt$/).
          with_content(/^\[authentication\]$/).
          with_content(/^rsa_key: \/etc\/pki\/pulp\/consumer\/rsa.key$/).
          with_content(/^\[client\]$/).
          with_content(/^role: consumer$/).
          with_content(/^\[filesystem\]$/).
          with_content(/^extensions_dir: \/usr\/lib\/pulp\/consumer\/extensions$/).
          with_content(/^repo_file: \/etc\/yum.repos.d\/pulp.repo$/).
          with_content(/^mirror_list_dir: \/etc\/yum.repos.d$/).
          with_content(/^gpg_keys_dir: \/etc\/pki\/pulp-gpg-keys$/).
          with_content(/^cert_dir: \/etc\/pki\/pulp\/client\/repo$/).
          with_content(/^id_cert_dir: \/etc\/pki\/pulp\/consumer\/$/).
          with_content(/^id_cert_filename: consumer-cert.pem$/).
          with_content(/^\[reboot\]$/).
          with_content(/^permit: false$/).
          with_content(/^delay: 3$/).
          with_content(/^\[logging\]$/).
          with_content(/^filename: \~\/.pulp\/consumer.log$/).
          with_content(/^call_log_filename: \~\/.pulp\/consumer_server_calls.log$/).
          with_content(/^\[output\]$/).
          with_content(/^poll_frequency_in_seconds: 1$/).
          with_content(/^enable_color: true$/).
          with_content(/^wrap_to_terminal: false$/).
          with_content(/^wrap_width: 80$/).
          with_content(/^\[messaging\]$/).
          with_content(/^scheme: tcp$/).
          with_content(/^host: foo.example.com$/).
          with_content(/^port: 5672$/).
          with_content(/^transport: qpid$/).
          with_content(/^\[profile\]$/).
          with_content(/^minutes: 240$/).
          with_ensure('file')
      end

    end

    context 'install with puppet param' do
      let(:params) do {
          'enable_puppet' => true,
        } end

      it { should contain_package('pulp-puppet-consumer-extensions').with_ensure('installed') }
      it { should contain_package('pulp-puppet-handlers').with_ensure('installed') }

      it 'should set puppet_bind.conf file' do
        should contain_file('/etc/pulp/agent/conf.d/puppet_bind.conf').
          with_content(/^\[main\]$/).
          with_content(/^enabled=1$/).
          with_content(/^\[types\]$/).
          with_content(/^bind=puppet_distributor$/).
          with_content(/^\[puppet_distributor\]$/).
          with_content(/^class=pulp_puppet.handlers.puppet.BindHandler$/).
          with_ensure('file')
      end

      it 'should set puppet_module.conf file' do
        should contain_file('/etc/pulp/agent/conf.d/puppet_module.conf').
          with_content(/^\[main\]$/).
          with_content(/^enabled=1$/).
          with_content(/^\[types\]$/).
          with_content(/^content=puppet_module$/).
          with_content(/^\[puppet_module\]$/).
          with_content(/^class=pulp_puppet.handlers.puppet.ModuleHandler$/).
          with_ensure('file')
      end
    end

    context 'install with nodes param' do
      let(:params) do {
          'enable_nodes' => true,
        } end

      it { should contain_package('pulp-nodes-consumer-extensions').with_ensure('installed') }
    end

    context 'install with rpm param' do
      let(:params) do {
          'enable_rpm' => true,
        } end

      it { should contain_package('pulp-rpm-consumer-extensions').with_ensure('installed') }
      it { should contain_package('pulp-rpm-yumplugins').with_ensure('installed') }
      it { should contain_package('pulp-rpm-handlers').with_ensure('installed') }

      it 'should set bind.conf file' do
        should contain_file('/etc/pulp/agent/conf.d/bind.conf').
          with_content(/^\[main\]$/).
          with_content(/^enabled=1$/).
          with_content(/^\[types\]$/).
          with_content(/^bind=yum_distributor$/).
          with_content(/^\[yum_distributor\]$/).
          with_content(/^class=pulp_rpm.handlers.bind.RepoHandler$/).
          with_ensure('file')
      end

      it 'should set linux.conf file' do
        should contain_file('/etc/pulp/agent/conf.d/linux.conf').
          with_content(/^\[main\]$/).
          with_content(/^enabled=1$/).
          with_content(/^\[types\]$/).
          with_content(/^system=Linux$/).
          with_content(/^\[Linux\]$/).
          with_content(/^class=pulp_rpm.handlers.linux.LinuxHandler$/).
          with_ensure('file')
      end

      it 'should set rpm.conf file' do
        should contain_file('/etc/pulp/agent/conf.d/rpm.conf').
          with_content(/^\[main\]$/).
          with_content(/^enabled=1$/).
          with_content(/^\[types\]$/).
          with_content(/^content=rpm,package_group$/).
          with_content(/^\[rpm\]$/).
          with_content(/^class=pulp_rpm.handlers.rpm.PackageHandler$/).
          with_content(/^\[package_group\]$/).
          with_content(/^class=pulp_rpm.handlers.rpm.GroupHandler$/).
          with_ensure('file')
      end
    end

    context 'install with params' do
      let(:params) do {
          'host' => 'pulp.company.net',
          'verify_ssl' => false,
        } end

      it 'should set the default file' do
        should contain_file('/etc/pulp/consumer/consumer.conf').
          with_content(/^\[server\]$/).
          with_content(/^host: pulp.company.net$/).
          with_content(/^verify_ssl: false$/).
          with_ensure('file')
      end
    end
  end
end
