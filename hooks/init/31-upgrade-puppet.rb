def puppet5_available?
  return true if `rpm -q puppet-agent --queryformat=%{version}`.start_with?('5.')

  yum_info = `yum info puppet-agent`

  available = yum_info.split('Available Packages')[1]
  return false if available.nil?

  version = available.split(/Version/)[1].split("\n")[0]
  version = version.delete(':').strip
  version.start_with?('5.')
end

def stop_services
  Kafo::Helpers.execute('katello-service stop')
end

def upgrade_puppet_package
  Kafo::Helpers.execute('yum upgrade -y puppetserver')
  Kafo::Helpers.execute('yum upgrade -y puppet-agent')
  Kafo::Helpers.execute('yum reinstall -y puppet-agent-oauth')
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
  PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_5_upgrade'.freeze

  fail_and_exit 'Puppet already installed and upgraded. Skipping.' if File.exist?(PUPPET_UPGRADE_COMPLETE)

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy_content = Kafo::Helpers.module_enabled?(@kafo, 'foreman_proxy_content')

  fail_and_exit 'Puppet 4 to 5 upgrade is not currently supported for the chosen scenario.' unless katello || foreman_proxy_content

  Kafo::Helpers.log_and_say :info, 'Upgrading puppet...'
  fail_and_exit 'Unable to find Puppet 5 packages, is the repository enabled?' unless puppet5_available?

  upgrade_step :stop_services
  upgrade_step :upgrade_puppet_package

  Kafo::Helpers.log_and_say :info, "Puppet 4 to 5 upgrade initialization complete, continuing with installation"
end
