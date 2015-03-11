# See bottom of the script for the command that kicks off the script

def reset
  stop_services
  reset_database
  reset_candlepin
  reset_pulp
  reset_elasticsearch
end

def rake(task)
  if Kafo::Helpers.command_exists?('foreman-rake')
    command = "foreman-rake #{task}"
  else
    user = param('katello_devel', 'user').value
    rvm = param('katello_devel', 'rvm_ruby').value
    command = "sudo su #{user} -c '/bin/bash --login -c \"rvm use #{rvm} && bundle exec rake #{task}\"'"
  end

  command
end

def service
  Kafo::Helpers.command_exists?('service-wait') ? 'service-wait' : 'service'
end

def stop_services
  Kafo::KafoConfigure.logger.info 'Ensuring services httpd and foreman-tasks are stopped.'
  Kafo::Helpers.execute("#{service} httpd stop")
  Kafo::Helpers.execute("#{service} foreman-tasks stop") if Kafo::Helpers.service_exists?('foreman-tasks')
end

def reset_database
  Kafo::KafoConfigure.logger.info 'Dropping database!'

  command = rake("db:drop 2>&1")

  if Kafo::Helpers.module_enabled?(@kafo, 'katello_devel')
    command = "cd #{param('katello_devel', 'deployment_dir').value}/foreman && #{command}"
  end

  Kafo::Helpers.execute(command)
end

def reset_candlepin
  Kafo::KafoConfigure.logger.info 'Dropping Candlepin database!'

  tomcat = File.exists?('/var/lib/tomcat') ? 'tomcat' : 'tomcat6'
  commands = [
    'rm -f /var/lib/katello/cpdb_done',
    'rm -f /var/lib/katello/cpinit_done',
    "#{service} #{tomcat} stop",
    'sudo su postgres -c "dropdb candlepin"'
  ]

  Kafo::Helpers.execute(commands)
end

def reset_pulp
  Kafo::KafoConfigure.logger.info 'Dropping Pulp database!'

  commands = [
    'rm -f /var/lib/pulp/init.flag',
    "#{service} httpd stop",
    "#{service} mongod stop",
    'rm -f /var/lib/mongodb/pulp_database*',
    "#{service} mongod start",
    'rm -rf /var/lib/pulp/{distributions,published,repos}/*'
  ]

  Kafo::Helpers.execute(commands)
end

def reset_elasticsearch
  Kafo::KafoConfigure.logger.info 'Dropping Elasticsearch!'
  commands = [
    "#{service} elasticsearch stop",
    'rm -rf /var/lib/elasticsearch/*',
  ]
  Kafo::Helpers.execute(commands)
end

reset if app_value(:reset) && !app_value(:noop)

