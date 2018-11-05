require 'fileutils'

STEP_DIRECTORY = '/etc/foreman-installer/applied_hooks/post/'

def upgrade_tasks
  status = Kafo::Helpers.execute('foreman-rake upgrade:run')
  fail_and_exit "Application Upgrade Failed" unless status
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
    upgrade_tasks if Kafo::Helpers.module_enabled?(@kafo, 'foreman')
    Kafo::Helpers.log_and_say :info, 'Upgrade completed!'
  else
    Kafo::Helpers.log_and_say :error, 'Upgrade failed during the installation phase. Fix the error and re-run the upgrade.'
  end
end
