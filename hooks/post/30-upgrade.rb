require 'fileutils'

STEP_DIRECTORY = '/etc/foreman-installer/applied_hooks/post/'

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
            "removed manually with # rm -rf /var/lib/elasticsearch.  "
  message += "Some packages are no longer needed and can be removed:  # yum erase #{rpms.join(' ')}"
  Kafo::Helpers.log_and_say :info, message
end

def add_export_distributor
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:add_export_distributor')
end

def remove_docker_v1_content
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:delete_docker_v1_content')
end

def update_puppet_repository_distributors
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:update_puppet_repository_distributors')
end

def update_subscription_facet_backend_data
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.0:update_subscription_facet_backend_data')
end

def set_virt_who_on_pools
  Kafo::Helpers.execute('foreman-rake katello:upgrades:3.3:import_subscriptions')
end

def remove_gutterball
  return true unless Kafo::Helpers.execute('rpm -q gutterball')
  Kafo::Helpers.execute("yum erase -y gutterball tfm-rubygem-foreman_gutterball gutterball-certs tfm-rubygem-hammer_cli_gutterball")

  ['tomcat', 'tomcat6'].each do |t|
    gutterball_dir = "/var/lib/#{t}/webapps/gutterball"
    Kafo::Helpers.execute("rm -rfv #{gutterball_dir}") if File.directory?(gutterball_dir)
  end
end

def remove_event_queue
  queue_present = `qpid-stat -q --ssl-certificate=/etc/pki/katello/qpid_client_striped.crt -b amqps://localhost:5671 | grep :event | wc -l`.chomp.to_i
  if queue_present > 0
    Kafo::Helpers.execute('qpid-config --ssl-certificate=/etc/pki/katello/qpid_client_striped.crt -b amqps://localhost:5671 del queue $(hostname -f):event --force > /dev/null 2>&1')
  else
    logger.info 'Event queue is already removed, skipping'
  end
end

def upgrade_step(step, options = {})
  noop = app_value(:noop) ? ' (noop)' : ''
  long_running = options[:long_running] ? ' (this may take a while) ' : ''
  run_always = options.fetch(:run_always, false)

  if run_always || app_value(:force_upgrade_steps) || !step_ran?(step)
    Kafo::Helpers.log_and_say :info, "Upgrade Step: #{step}#{long_running}#{noop}..."
    unless app_value(:noop)
      status = send(step)
      fail_and_exit "Upgrade step #{step} failed. Check logs for more information." unless status
      touch_step(step)
    end
  end
end

def touch_step(step)
  FileUtils.mkpath(STEP_DIRECTORY) unless Dir.exists?(STEP_DIRECTORY)
  FileUtils.touch(step_path(step))
end

def step_ran?(step)
  File.exists?(step_path(step))
end

def step_path(step)
  File.join(STEP_DIRECTORY, step.to_s)
end

def fail_and_exit(message)
  Kafo::Helpers.log_and_say :error, message
  kafo.class.exit 1
end

if app_value(:upgrade)
  if [0, 2].include?(@kafo.exit_code)
    upgrade_step :restart_services, :run_always => true

    if Kafo::Helpers.module_enabled?(@kafo, 'katello')
      upgrade_step :db_seed, :run_always => true
      upgrade_step :import_package_groups, :long_running => true
      upgrade_step :import_rpms, :long_running => true
      upgrade_step :import_distributions, :long_running => true
      upgrade_step :import_puppet_modules, :long_running => true
      upgrade_step :import_subscriptions, :long_running => true
      upgrade_step :elasticsearch_message
      upgrade_step :add_export_distributor, :long_running => true
      upgrade_step :remove_docker_v1_content, :long_running => true
      upgrade_step :update_puppet_repository_distributors, :long_running => true
      upgrade_step :update_subscription_facet_backend_data, :long_running => true
      upgrade_step :remove_gutterball
      upgrade_step :remove_event_queue
      upgrade_step :set_virt_who_on_subscriptions, :long_running => true
    end

    if [0, 2].include? @kafo.exit_code
      Kafo::Helpers.log_and_say :info, 'Upgrade completed!'
    end
  else
    Kafo::Helpers.log_and_say :error, 'Upgrade failed during the installation phase. Fix the error and re-run the upgrade.'
  end
end
