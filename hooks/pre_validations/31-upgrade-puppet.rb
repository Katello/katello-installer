def fail_and_exit(message)
  Kafo::Helpers.log_and_say :error, message
  kafo.class.exit 1
end

if app_value(:upgrade_puppet)
  PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_5_upgrade'.freeze

  fail_and_exit 'Puppet already installed and upgraded. Skipping.' if File.exist?(PUPPET_UPGRADE_COMPLETE)

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy_content = Kafo::Helpers.module_enabled?(@kafo, 'foreman_proxy_content')

  fail_and_exit 'Puppet 4 to 5 upgrade is not currently supported for the chosen scenario.' unless katello || foreman_proxy_content

  Kafo::Helpers.log_and_say :info, 'Resetting puppet params...'

  if !app_value(:noop)
    Kafo::Helpers.reset_value(param('puppet', 'server_puppetserver_version'))
  end

  Kafo::Helpers.log_and_say :info, "Puppet 4 to 5 upgrade param reset, continuing with installation"
end
