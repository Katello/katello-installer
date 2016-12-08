def stop_services
  Kafo::Helpers.execute('katello-service stop --exclude mongod,postgresql')
end

def start_databases
  Kafo::Helpers.execute('katello-service start --only mongod,postgresql')
end

def start_httpd
  Kafo::Helpers.execute('katello-service start --only httpd')
end

def start_qpidd
  Kafo::Helpers.execute('katello-service start --only qpidd,qdrouterd')
end

def start_pulp
  Kafo::Helpers.execute('katello-service start --only pulp_workers,pulp_resource_manager,pulp_celerybeat')
end

def update_http_conf
  Kafo::Helpers.execute("grep -F -q 'Include \"/etc/httpd/conf.modules.d/*.conf\"' /etc/httpd/conf/httpd.conf || \
                       echo -e '<IfVersion >= 2.4> \n    Include \"/etc/httpd/conf.modules.d/*.conf\"\n</IfVersion>' \
                       >> /etc/httpd/conf/httpd.conf")
end

def migrate_candlepin
  Kafo::Helpers.execute("/usr/share/candlepin/cpdb --update --password #{Kafo::Helpers.read_cache_data('candlepin_db_password')}")
end

def start_tomcat
  Kafo::Helpers.execute('katello-service start --only tomcat,tomcat6')
end

def remove_gutterball
  gbpresent = `runuser - postgres -c "psql -l | grep gutterball | wc -l"`.chomp.to_i
  if gbpresent > 0
    Kafo::Helpers.execute('runuser - postgres -c "dropdb gutterball"')
  else
    logger.info 'Gutterball is already removed, skipping'
  end
end

def migrate_pulp
  # Fix pid if neccessary
  if Kafo::Helpers.execute("grep -qe '7.[[:digit:]]' /etc/redhat-release")
    Kafo::Helpers.execute("sed -i -e 's?/var/run/mongodb/mongodb.pid?/var/run/mongodb/mongod.pid?g' /etc/mongod.conf")
  end

  # Start mongo if not running
  unless Kafo::Helpers.execute('pgrep mongod')
    Kafo::Helpers.execute('service-wait mongod start')
  end

  Kafo::Helpers.execute('su - apache -s /bin/bash -c pulp-manage-db')
end

def migrate_foreman
  Kafo::Helpers.execute('foreman-rake -- config -k use_pulp_oauth -v true')
  Kafo::Helpers.execute('foreman-rake db:migrate')
  Kafo::Helpers.execute('foreman-rake -- config -k use_pulp_oauth -v false')
end

def remove_nodes_importers
  Kafo::Helpers.execute("mongo pulp_database --eval 'db.repo_importers.remove({'importer_type_id': \"nodes_http_importer\"});'")
end

def remove_nodes_distributors
  Kafo::Helpers.execute("mongo pulp_database --eval  'db.repo_distributors.remove({'distributor_type_id': \"nodes_http_distributor\"});'")
end

def fix_katello_settings_file
  settings_file = '/etc/foreman/plugins/katello.yaml'
  settings = JSON.parse(JSON.dump(YAML.load_file(settings_file)), :symbolize_names => true)

  return true unless settings.key?(:common)

  settings = {:katello => settings[:common]}
  File.open(settings_file, 'w') do |file|
    file.write(settings.to_yaml)
  end
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

if app_value(:upgrade)
  if app_value(:upgrade_puppet)
    fail_and_exit 'Concurrent use of --upgrade and --upgrade-puppet is not supported. '\
                  'Please run --upgrade first, then --upgrade-puppet.'
  end

  Kafo::Helpers.log_and_say :info, 'Upgrading...'
  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  capsule = @kafo.param('foreman_proxy_plugin_pulp', 'pulpnode_enabled').value

  upgrade_step :stop_services
  upgrade_step :start_databases
  upgrade_step :update_http_conf

  if katello || capsule
    upgrade_step :migrate_pulp
    upgrade_step :start_httpd
    upgrade_step :start_qpidd
    upgrade_step :start_pulp
  end

  if capsule
    upgrade_step :remove_nodes_importers
  end

  if katello
    upgrade_step :migrate_candlepin, :run_always => true
    upgrade_step :remove_gutterball
    upgrade_step :start_tomcat
    upgrade_step :fix_katello_settings_file
    upgrade_step :migrate_foreman
    upgrade_step :remove_nodes_distributors
  end

  Kafo::Helpers.log_and_say :info, 'Upgrade Step: Running installer...'
end
