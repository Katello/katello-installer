def puppet4_available?
  success = []
  success << Kafo::Helpers.execute('yum info puppet-agent')
  success << Kafo::Helpers.execute('yum info puppetserver')
  !success.include?(false)
end

def stop_services
  Kafo::Helpers.execute('katello-service stop')
end

def upgrade_puppet_package
  Kafo::Helpers.execute('yum remove -y puppet-server')
  Kafo::Helpers.execute('yum install -y puppetserver')
  Kafo::Helpers.execute('yum install -y puppet-agent')
end

def start_httpd
  Kafo::Helpers.execute('katello-service start --only httpd')
end

def remove_puppet_port_httpd
  Kafo::Helpers.execute('sed -i "/^Listen 8140$/d" /etc/httpd/conf/ports.conf')
end

def copy_data
  success = []
  success << Kafo::Helpers.execute('cp -rfp /etc/puppet/environments /etc/puppetlabs/code/environments') if File.directory?('/etc/puppet/environments')
  success << Kafo::Helpers.execute('cp -rfp /var/lib/puppet/ssl /etc/puppetlabs/puppet') if File.directory?('/var/lib/puppet/ssl')
  success << Kafo::Helpers.execute('cp -rfp /var/lib/puppet/foreman_cache_data /opt/puppetlabs/puppet/cache/') if File.directory?('/var/lib/puppet/foreman_cache_data')
  !success.include?(false)
end

def upgrade_step(step)
  noop = app_value(:noop) ? ' (noop)' : ''

  Kafo::Helpers.log_and_say :info, "Upgrade Step: #{step}#{noop}..."
  unless app_value(:noop)
    status = send(step)
    fail_and_exit "Upgrade step #{step} failed. Check logs for more information." unless status
  end
end

def fail_and_exit(message)
  Kafo::Helpers.log_and_say :error, message
  kafo.class.exit 1
end

if app_value(:upgrade_puppet)
  PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_4_upgrade'.freeze

  fail_and_exit 'Puppet already installed and upgraded. Skipping.' if File.exist?(PUPPET_UPGRADE_COMPLETE)
  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy_content = @kafo.param('foreman_proxy_plugin_pulp', 'pulpnode_enabled').value

  fail_and_exit 'Puppet 3 to 4 upgrade is not currently supported for the chosen scenario.' unless katello || foreman_proxy_content

  Kafo::Helpers.log_and_say :info, 'Upgrading puppet...'
  fail_and_exit 'Unable to find Puppet 4 packages, is the repository enabled?' unless puppet4_available?

  if !app_value(:noop)
    Kafo::Helpers.reset_value(param('foreman', 'puppet_home'))
    Kafo::Helpers.reset_value(param('foreman', 'puppet_ssldir'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_ca'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_cert'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_key'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetdir'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'ssldir'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetca_cmd'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetrun_cmd'))
    Kafo::Helpers.reset_value(param('foreman_proxy_plugin_pulp', 'puppet_content_dir'))
  end

  upgrade_step :upgrade_puppet_package
  upgrade_step :stop_services
  upgrade_step :copy_data
  upgrade_step :remove_puppet_port_httpd
  upgrade_step :start_httpd

  File.open(PUPPET_UPGRADE_COMPLETE, 'w') { |file| file.write("Puppet 3 to 4 upgrade completed on #{Time.now}") }
  Kafo::Helpers.log_and_say :info, "Puppet 3 to 4 upgrade initialization complete, continuing with installation"
end
