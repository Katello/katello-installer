# See bottom of the script for the command that kicks off the script

def clear_puppet_environments
  if File.directory?('/etc/puppet/environments')
    `rm -rf /etc/puppet/environments/*`
    Kafo::KafoConfigure.logger.info 'Puppet environment data successfully removed.'
  else
    Kafo::KafoConfigure.logger.warn 'Puppet environment data directory not present at \'/etc/puppet/environments\''
  end
end

clear_puppet_environments if app_value(:clear_puppet_environments) && !app_value(:noop)
