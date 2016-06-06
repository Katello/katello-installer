def restart_services
  Kafo::Helpers.execute('katello-service restart')
end

def db_seed
  Kafo::Helpers.execute('foreman-rake db:seed')
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

def elasticsearch_message
  return true unless Kafo::Helpers.execute('rpm -q elasticsearch')

  rpms = ['ruby193-rubygem-tire', 'tfm-rubygem-tire', 'elasticsearch', 'sigar-java', 'sigar', 'snappy-java', 'lucene4-contrib', 'lucene4']
  message = "Elasticsearch has been removed as a dependency.  The database files can be "\
            "removed manually with #rm -rf /var/lib/elasticsearch.  "
  message += "Some packages are no longer needed and can be removed:  #rpm -e #{rpms.join(' ')}"
  Kafo::Helpers.log_and_say :info, message
end

def remove_docker_v1_content
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:delete_docker_v1_content')
end

def update_puppet_repository_distributors
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:update_puppet_repository_distributors')
end

def remove_gutterball
  return true unless Kafo::Helpers.execute('rpm -q gutterball')
  Kafo::Helpers.execute("rpm -e gutterball tfm-rubygem-foreman_gutterball gutterball-certs tfm-rubygem-hammer_cli_gutterball")
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
    upgrade_step :import_package_groups, :long_running => true
    upgrade_step :import_rpms, :long_running => true
    upgrade_step :import_distributions, :long_running => true
    upgrade_step :import_puppet_modules, :long_running => true
    upgrade_step :import_subscriptions, :long_running => true
    upgrade_step :elasticsearch_message
    upgrade_step :remove_docker_v1_content, :long_running => true
    upgrade_step :update_puppet_repository_distributors, :long_running => true
    upgrade_step :remove_gutterball
  end

  if [0,2].include? @kafo.exit_code
    Kafo::Helpers.log_and_say :info, 'Katello upgrade completed!'
  end
end
