PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_4_upgrade'.freeze

def restart_services
  Kafo::Helpers.execute('katello-service restart')
end

def upgrade_step(step, options = {})
  noop = app_value(:noop) ? ' (noop)' : ''
  long_running = options[:long_running] ? ' (this may take a while) ' : ''

  Kafo::Helpers.log_and_say :info, "Upgrade Step: #{step}#{long_running}#{noop}..."
  unless app_value(:noop)
    status = send(step)
    fail_and_exit "Upgrade step #{step} failed. Check logs for more information." unless status
  end
end

def fail_and_exit(message)
  Kafo::Helpers.log_and_say :error, message
  kafo.class.exit 1
end

def puppet4_installed?
  success = []
  success << Kafo::Helpers.execute('rpm -q puppet-agent', false, false)
  success << Kafo::Helpers.execute('rpm -q puppetserver', false, false)
  !success.include?(false)
end

def puppet_upgrade_complete?
  File.exist?(PUPPET_UPGRADE_COMPLETE)
end

if app_value(:upgrade_puppet) && !puppet_upgrade_complete?

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy = @kafo.param('foreman_proxy_plugin_pulp', 'pulpnode_enabled').value

  if katello || foreman_proxy
    upgrade_step :restart_services
  end

  if [0, 2].include? @kafo.exit_code
    File.open(PUPPET_UPGRADE_COMPLETE, 'w') do |file|
      file.write("Puppet 3 to 4 upgrade completed on #{Time.now}")
    end
  end
end

if !app_value(:upgrade_puppet) && !puppet_upgrade_complete? && puppet4_installed?
  File.open(PUPPET_UPGRADE_COMPLETE, 'w') do |file|
    file.write("No Puppet 3 to 4 upgrade performed. Puppet 4 installed on #{Time.now}.")
  end
end
