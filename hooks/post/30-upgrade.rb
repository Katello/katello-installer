require 'fileutils'

STEP_DIRECTORY = '/etc/foreman-installer/applied_hooks/post/'
MONGO_REMOVAL_COMPLETE = '/etc/foreman-installer/.mongo_2_removed'.freeze

def upgrade_tasks
  status = Kafo::Helpers.execute('foreman-rake upgrade:run')
  fail_and_exit "Application Upgrade Failed" unless status
end

def remove_legacy_mongo
  # Check to see if the RPMS exist and if so remove them and create the upgrade done file, and install rh-mongodb34-mongodb-syspaths.
  return if File.exist?(MONGO_REMOVAL_COMPLETE)

  if `rpm -q mongodb --queryformat=%{version}`.start_with?('2.')
    logger.warn 'removing MongoDB 2.x packages, config and log files.'
    Kafo::Helpers.execute('yum remove -y mongodb-2* mongodb-server-2* > /dev/null 2>&1')
    Kafo::Helpers.execute('rm -rf /etc/mongod.conf /var/log/mongodb')
  else
    logger.info 'MongoDB 2.x not detected, skipping'
  end

  Kafo::Helpers.execute('yum install -y -q rh-mongodb34-syspaths')
  File.open(MONGO_REMOVAL_COMPLETE, 'w') do |file|
    file.write("MongoDB 2.x removal completed on #{Time.now}")
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

upgrade_step :remove_legacy_mongo

if app_value(:upgrade)
  if [0, 2].include?(@kafo.exit_code)
    upgrade_tasks if module_enabled?('foreman')
    Kafo::Helpers.log_and_say :info, 'Upgrade completed!'
  else
    Kafo::Helpers.log_and_say :error, 'Upgrade failed during the installation phase. Fix the error and re-run the upgrade.'
  end
end
