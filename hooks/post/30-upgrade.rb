def migrate_pulp
  Kafo::Helpers.execute('su - apache -s /bin/bash -c pulp-manage-db')
end

def restart_services
  Kafo::Helpers.execute('katello-service restart')
end

def db_seed
  Kafo::Helpers.execute('foreman-rake db:seed')
end

def errata_import
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.1:import_errata')
end

def update_gpg_urls
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.2:update_gpg_key_urls')
end

def update_repository_metadata
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.2:update_metadata_expire')
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

if app_value(:upgrade)
  if Kafo::Helpers.module_enabled?(@kafo, 'katello') || @kafo.param('capsule', 'pulp').value
    upgrade_step :migrate_pulp
    upgrade_step :restart_services
  end

  if Kafo::Helpers.module_enabled?(@kafo, 'katello')
    upgrade_step :db_seed
    upgrade_step :errata_import, :long_running => true
    upgrade_step :update_gpg_urls, :long_running => true
    upgrade_step :update_repository_metadata, :long_running => true
  end

  if [0,2].include? @kafo.exit_code
    Kafo::Helpers.log_and_say :info, 'Katello upgrade completed!'
  end
end
