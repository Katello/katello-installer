def stop_services
  Kafo::Helpers.execute('katello-service stop --exclude mongod,postgresql')
end

def start_databases
  Kafo::Helpers.execute('katello-service start --only mongod,postgresql')
end

def start_httpd
  Kafo::Helpers.execute('katello-service start --only httpd')
end

def update_http_conf
  Kafo::Helpers.execute("grep -q -F 'Include \"/etc/httpd/conf.modules.d/*.conf\"' /etc/httpd/conf/httpd.conf || \
		         echo 'Include \"/etc/httpd/conf.modules.d/*.conf\"' >> /etc/httpd/conf/httpd.conf")
end

def migrate_candlepin
  Kafo::Helpers.execute("/usr/share/candlepin/cpdb --update --password #{Kafo::Helpers.read_cache_data('candlepin_db_password')}")
end

def migrate_gutterball
  if File.exist?('/usr/bin/gutterball-db')
    Kafo::Helpers.execute("/usr/bin/gutterball-db migrate")
  else
    true
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
  Kafo::Helpers.execute('foreman-rake db:migrate')
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
  Kafo::Helpers.log_and_say :info, 'Upgrading...'
  upgrade_step :stop_services
  upgrade_step :start_databases
  upgrade_step :update_http_conf if Kafo::Helpers.module_enabled?(@kafo, 'katello') 

  if Kafo::Helpers.module_enabled?(@kafo, 'katello') || @kafo.param('capsule', 'pulp').value
    upgrade_step :migrate_pulp
    upgrade_step :start_httpd
  end

  if Kafo::Helpers.module_enabled?(@kafo, 'katello')
    upgrade_step :migrate_candlepin
    upgrade_step :migrate_foreman
    upgrade_step :migrate_gutterball
  end

  Kafo::Helpers.log_and_say :info, 'Upgrade Step: Running installer...'
end
