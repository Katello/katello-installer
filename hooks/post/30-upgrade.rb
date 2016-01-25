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

def import_package_groups
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.4:import_package_groups')
end

def import_rpms
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.4:import_rpms')
end

def import_distributions
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.4:import_distributions')
end

def import_puppet_modules
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.4:import_puppet_modules')
end

def import_subscriptions
  Kafo::Helpers.execute('foreman-rake katello:upgrades:2.4:import_subscriptions')
end

def remove_elasticsearch
  if Kafo::Helpers.execute('rpm -q elasticsearch')
    gems = ['ruby193-rubygem-tire', 'tfm-rubygem-tire', 'elasticsearch', 'sigar', 'snappy-java', 'lucene4-contrib', 'lucene4']
    gems.each do |gem|
      Kafo::Helpers.execute("rpm -e #{gem}")
    end
    message = "Elasticsearch has been removed as a dependency, the database files can be "\
              "removed manually with #rm -rf /var/lib/elasticsearch"
    Kafo::Helpers.log_and_say :info, message
  end
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
  upgrade_step :restart_services

  if Kafo::Helpers.module_enabled?(@kafo, 'katello')
    upgrade_step :db_seed
    upgrade_step :errata_import, :long_running => true
    upgrade_step :update_gpg_urls, :long_running => true
    upgrade_step :update_repository_metadata, :long_running => true
    upgrade_step :import_package_groups, :long_running => true
    upgrade_step :import_rpms, :long_running => true
    upgrade_step :import_distributions, :long_running => true
    upgrade_step :import_puppet_modules, :long_running => true
    upgrade_step :import_subscriptions, :long_running => true
    upgrade_step :remove_elasticsearch
  end

  if [0,2].include? @kafo.exit_code
    Kafo::Helpers.log_and_say :info, 'Katello upgrade completed!'
  end
end
