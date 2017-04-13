# See bottom of the script for the command that kicks off the script

def reset
  if foreman_installed?

    stop_services
    reset_database
    reset_candlepin
    reset_pulp

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
  Kafo::Helpers.execute('service httpd stop && service foreman-tasks stop')
end

def reset_database
  Kafo::KafoConfigure.logger.info 'Dropping database!'
  Kafo::Helpers.execute('foreman-rake db:drop 2>&1')
end

def reset_candlepin
  Kafo::KafoConfigure.logger.info 'Dropping Candlepin database!'

  tomcat = File.exists?('/var/lib/tomcat') ? 'tomcat' : 'tomcat6'
  commands = [
    'rm -f /var/lib/candlepin/cpdb_done',
    'rm -f /var/lib/candlepin/cpinit_done',
    "service #{tomcat} stop",
    'sudo su postgres -c "dropdb candlepin"'
  ]

  Kafo::Helpers.execute(commands)
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

  Kafo::Helpers.execute(commands)
end

if app_value(:reset) && !app_value(:noop)
  response = ask('Are you sure you want to continue? This will drop the databases, reset all configurations that you have made and bring the server back to a fresh install. [y/n]')
  if response.downcase != 'y'
    $stderr.puts '** cancelled **'
    kafo.class.exit(1)
  else
    reset
  end
end
