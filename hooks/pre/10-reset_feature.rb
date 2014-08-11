# See bottom of the script for the command that kicks off the script

def reset
  if foreman_installed?

    stop_services
    reset_database
    reset_candlepin
    reset_pulp
    reset_elasticsearch

  else
    Kafo::KafoConfigure.logger.warn 'Katello not installed yet, can not drop database!'
  end
end

def foreman_installed?
  `which foreman-rake > /dev/null 2>&1`
  $?.success?
end

def stop_services
  Kafo::KafoConfigure.logger.info 'Ensuring services httpd and foreman-tasks are stopped.'
  execute('service httpd stop && service foreman-tasks stop')
end

def reset_database
  Kafo::KafoConfigure.logger.info 'Dropping database!'
  execute('foreman-rake db:drop 2>&1')
end

def reset_candlepin
  Kafo::KafoConfigure.logger.info 'Dropping Candlepin database!'

  tomcat = File.exists?('/var/lib/tomcat') ? 'tomcat' : 'tomcat6'
  commands = [
    'rm -f /var/lib/katello/cpdb_done',
    'rm -f /var/lib/katello/cpinit_done',
    "service #{tomcat} stop",
    'sudo su postgres -c "dropdb candlepin"'
  ]

  execute(commands)
end

def reset_pulp
  Kafo::KafoConfigure.logger.info 'Dropping Pulp database!'

  commands = [
    'rm -f /var/lib/pulp/init.flag',
    'service-wait httpd stop',
    'service-wait mongod stop',
    'rm -f /var/lib/mongodb/pulp_database*',
    'service-wait mongod start',
    'rm -rf /var/lib/pulp/{distributions,published,repos}/*'
  ]

  execute(commands)
end

def reset_elasticsearch
  Kafo::KafoConfigure.logger.info 'Dropping Elasticsearch!'
  commands = [
    'service-wait elasticsearch stop',
    'rm -rf /var/lib/elasticsearch/*',
  ]
  execute(commands)
end

def execute(commands = [])
  commands = commands.is_a?(Array) ? commands : [commands]

  commands.each do |command|
    output = `#{command} 2>&1`

    if !$?.success?
      Kafo::KafoConfigure.logger.error output.to_s
    else
      Kafo::KafoConfigure.logger.debug output.to_s
    end
  end
end

reset if app_value(:reset) && !app_value(:noop)

