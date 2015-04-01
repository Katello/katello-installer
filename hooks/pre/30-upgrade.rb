def migrate_candlepin
  Kafo::Helpers.execute("/usr/share/candlepin/cpdb --update --password #{Kafo::Helpers.read_cache_data('candlepin_db_password')}")
end

def migrate_gutterball
  Kafo::Helpers.execute("/usr/bin/gutterball-db migrate")
end

def migrate_pulp
  # Fix pid if neccessary
  if Kafo::Helpers.execute("grep -qe '7.[[:digit:]]' /etc/redhat-release")
    Kafo::Helpers.execute("sed -i -e 's?/var/run/mongodb/mongodb.pid?/var/run/mongodb/mongod.pid?g' /etc/mongodb.conf")
  end

  # Start mongo if not running
  unless Kafo::Helpers.execute('pgrep mongod')
    Kafo::Helpers.execute('service-wait mongod start')
  end

  Kafo::Helpers.execute('sudo -u apache pulp-manage-db')
end

def migrate_foreman
  Kafo::Helpers.execute('foreman-rake db:migrate')
end

def upgrade_step(step)
  noop = app_value(:noop) ? ' (noop)' : ''

  Kafo::Helpers.log_and_say :info, "Upgrade Step: #{step.to_s}#{noop}..."
  send(step) unless app_value(:noop)
end

if app_value(:upgrade)
  Kafo::Helpers.log_and_say :info, 'Upgrading...'

  if Kafo::Helpers.module_enabled?(@kafo, 'katello') || @kafo.param('capsule', 'pulp').value
    upgrade_step :migrate_pulp
  end

  if Kafo::Helpers.module_enabled?(@kafo, 'katello')
    upgrade_step :migrate_candlepin
    upgrade_step :migrate_foreman
    upgrade_step :migrate_gutterball
  end

  Kafo::Helpers.log_and_say :info, 'Upgrade Step: Running installer...'
end
