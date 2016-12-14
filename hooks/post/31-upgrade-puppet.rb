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

if app_value(:upgrade_puppet)

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy = @kafo.param('foreman_proxy_plugin_pulp', 'pulpnode_enabled').value

  if katello || foreman_proxy
    upgrade_step :restart_services
  end

  if [0, 2].include? @kafo.exit_code
    Kafo::Helpers.log_and_say :info, 'Puppet upgrade completed!'
  end
end
