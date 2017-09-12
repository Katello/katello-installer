require 'fileutils'

STEP_DIRECTORY = '/etc/foreman-installer/applied_hooks/pre/'
SSL_BUILD_DIR = param('certs', 'ssl_build_dir').value

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
  db_host = param('katello', 'candlepin_db_host').value
  db_port = param('katello', 'candlepin_db_port').value
  db_name = param('katello', 'candlepin_db_name').value
  db_user = param('katello', 'candlepin_db_user').value
  db_password = param('katello', 'candlepin_db_password').value
  db_ssl = param('katello', 'candlepin_db_ssl').value
  db_ssl_verify = param('katello', 'candlepin_db_ssl_verify').value
  db_uri = "//#{db_host}" + (db_port.nil? ? '' : ":#{db_port}") + "/#{db_name}"
  if db_ssl
    db_uri += "?ssl=true"
    db_uri += "&sslfactory=org.postgresql.ssl.NonValidatingFactory" unless db_ssl_verify
  end
  Kafo::Helpers.execute("/usr/share/candlepin/cpdb --update --database '#{db_uri}' --user #{db_user} --password #{db_password}")
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
  Kafo::Helpers.execute('foreman-rake db:migrate')
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

def mark_qpid_cert_for_update
  hostname = param('certs', 'node_fqdn').value

  all_cert_names = Dir.glob(File.join(SSL_BUILD_DIR, hostname, '*.noarch.rpm')).map do |rpm|
    File.basename(rpm).sub(/-1\.0-\d+\.noarch\.rpm/, '')
  end.uniq

  if (qpid_cert = all_cert_names.find { |cert| cert =~ /-qpid-broker$/ })
    path = File.join(*[SSL_BUILD_DIR, hostname, qpid_cert].compact)
    Kafo::Helpers.log_and_say :info, "Marking certificate #{path} for update"
    FileUtils.touch("#{path}.update")
  else
    Kafo::Helpers.log_and_say :debug, "No existing broker cert found; skipping update"
  end
end

# rubocop:disable MethodLength
# rubocop:disable Style/MultipleComparison
def upgrade_qpid_paths
  qpid_dir = '/var/lib/qpidd'
  qpid_data_dir = "#{qpid_dir}/.qpidd"

  qpid_linearstore = "#{qpid_data_dir}/qls"
  if Dir.glob("#{qpid_linearstore}/jrnl/**/*.jrnl").empty? && !File.exist?("#{qpid_linearstore}/dat")
    logger.info 'Qpid directory upgrade is already complete, skipping'
  else
    backup_file = "/var/cache/qpid_queue_backup.tar.gz"

    unless File.exist?(backup_file)
      # Backup data directory before upgrade
      puts "Backing up #{qpid_dir} in case of migration failure"
      Kafo::Helpers.execute("tar -czf #{backup_file} #{qpid_dir}")
    end

    # Make new directory structure for migration
    Kafo::Helpers.execute("mkdir -p #{qpid_linearstore}/p001/efp/2048k/in_use")
    Kafo::Helpers.execute("mkdir -p #{qpid_linearstore}/p001/efp/2048k/returned")
    Kafo::Helpers.execute("mkdir -p #{qpid_linearstore}/jrnl2")

    if File.exist?("#{qpid_linearstore}/dat") && File.exist?("#{qpid_linearstore}/dat2")
      Kafo::Helpers.execute("rm -rf #{qpid_linearstore}/dat2")
    end

    if File.exist?("#{qpid_linearstore}/dat") && !File.exist?("#{qpid_linearstore}/dat2}")
      # Move dat directory to new location dat2
      Kafo::Helpers.execute("mv #{qpid_linearstore}/dat #{qpid_linearstore}/dat2")
    end

    # Move qpid jrnl files
    Dir.foreach("#{qpid_linearstore}/jrnl") do |queue_name|
      next if queue_name == '.' || queue_name == '..'

      puts "Moving #{queue_name}"
      Kafo::Helpers.execute("mkdir -p #{qpid_linearstore}/jrnl2/#{queue_name}/")
      Dir.foreach("#{qpid_linearstore}/jrnl/#{queue_name}") do |jrnlfile|
        next if jrnlfile == '.' || jrnlfile == '..'

        Kafo::Helpers.execute("mv #{qpid_linearstore}/jrnl/#{queue_name}/#{jrnlfile} #{qpid_linearstore}/p001/efp/2048k/in_use/#{jrnlfile}")
        Kafo::Helpers.execute("ln -s #{qpid_linearstore}/p001/efp/2048k/in_use/#{jrnlfile} #{qpid_linearstore}/jrnl2/#{queue_name}/#{jrnlfile}")
        unless $?.success?
          logger.error "There was an error during the migration, exiting. A backup of the #{qpid_dir} is at /var/cache/qpid_queue_backup.tar.gz"
          kafo.class.exit(1)
        end
      end
    end

    # Restore access
    Kafo::Helpers.execute("chown -R qpidd:qpidd #{qpid_dir}")

    # restore SELinux context by current policy
    Kafo::Helpers.execute("restorecon -FvvR #{qpid_dir}")
    logger.info 'Qpid path upgrade complete'
    Kafo::Helpers.execute("rm -f #{backup_file}")
    logger.info 'Removing old jrnl directory'
    Kafo::Helpers.execute("rm -rf #{qpid_linearstore}/jrnl")
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
  if app_value(:upgrade_puppet)
    fail_and_exit 'Concurrent use of --upgrade and --upgrade-puppet is not supported. '\
                  'Please run --upgrade first, then --upgrade-puppet.'
  end

  Kafo::Helpers.log_and_say :info, 'Upgrading, to monitor the progress on all related services, please do:'
  Kafo::Helpers.log_and_say :info, '  foreman-tail | tee upgrade-$(date +%Y-%m-%d-%H%M).log'
  sleep 3

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy_content = @kafo.param('foreman_proxy_plugin_pulp', 'pulpnode_enabled').value

  upgrade_step :stop_services, :run_always => true
  upgrade_step :start_databases, :run_always => true
  upgrade_step :update_http_conf, :run_always => true

  if katello || foreman_proxy_content
    upgrade_step :upgrade_qpid_paths
    upgrade_step :migrate_pulp, :run_always => true
    upgrade_step :start_httpd, :run_always => true
    upgrade_step :start_qpidd, :run_always => true
    upgrade_step :start_pulp, :run_always => true
  end

  if foreman_proxy_content
    upgrade_step :remove_nodes_importers
  end

  if katello
    upgrade_step :mark_qpid_cert_for_update
    upgrade_step :migrate_candlepin, :run_always => true
    upgrade_step :remove_gutterball
    upgrade_step :start_tomcat, :run_always => true
    upgrade_step :fix_katello_settings_file
    upgrade_step :migrate_foreman, :run_always => true
    upgrade_step :remove_nodes_distributors
  end

  Kafo::Helpers.log_and_say :info, 'Upgrade Step: Running installer...'
end
