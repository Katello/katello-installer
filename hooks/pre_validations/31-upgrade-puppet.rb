def fail_and_exit(message)
  Kafo::Helpers.log_and_say :error, message
  kafo.class.exit 1
end

if app_value(:upgrade_puppet)
  PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_4_upgrade'.freeze

  fail_and_exit 'Puppet already installed and upgraded. Skipping.' if File.exist?(PUPPET_UPGRADE_COMPLETE)

  katello = Kafo::Helpers.module_enabled?(@kafo, 'katello')
  foreman_proxy_content = Kafo::Helpers.module_enabled?(@kafo, 'foreman_proxy_content')

  fail_and_exit 'Puppet 3 to 4 upgrade is not currently supported for the chosen scenario.' unless katello || foreman_proxy_content

  Kafo::Helpers.log_and_say :info, 'Resetting puppet params...'

  if !app_value(:noop)
    if katello
      Kafo::Helpers.reset_value(param('foreman', 'puppet_home'))
      Kafo::Helpers.reset_value(param('foreman', 'puppet_ssldir'))
    end

    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_ca'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_cert'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppet_ssl_key'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetdir'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'ssldir'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetca_cmd'))
    Kafo::Helpers.reset_value(param('foreman_proxy', 'puppetrun_cmd'))
    Kafo::Helpers.reset_value(param('foreman_proxy_plugin_pulp', 'puppet_content_dir'))

    Kafo::Helpers.reset_value(param('puppet', 'server_implementation'))
    Kafo::Helpers.reset_value(param('puppet', 'autosign'))
    Kafo::Helpers.reset_value(param('puppet', 'client_package'))
    Kafo::Helpers.reset_value(param('puppet', 'codedir'))
    Kafo::Helpers.reset_value(param('puppet', 'configtimeout'))
    Kafo::Helpers.reset_value(param('puppet', 'dir'))
    Kafo::Helpers.reset_value(param('puppet', 'logdir'))
    Kafo::Helpers.reset_value(param('puppet', 'rundir'))
    Kafo::Helpers.reset_value(param('puppet', 'ssldir'))
    Kafo::Helpers.reset_value(param('puppet', 'vardir'))
    Kafo::Helpers.reset_value(param('puppet', 'server_common_modules_path'))
    Kafo::Helpers.reset_value(param('puppet', 'server_default_manifest_path'))
    Kafo::Helpers.reset_value(param('puppet', 'server_dir'))
    Kafo::Helpers.reset_value(param('puppet', 'server_envs_dir'))
    Kafo::Helpers.reset_value(param('puppet', 'server_external_nodes'))
    Kafo::Helpers.reset_value(param('puppet', 'server_jruby_gem_home'))
    Kafo::Helpers.reset_value(param('puppet', 'server_package'))
    Kafo::Helpers.reset_value(param('puppet', 'server_puppetserver_dir'))
    Kafo::Helpers.reset_value(param('puppet', 'server_puppetserver_vardir'))
    Kafo::Helpers.reset_value(param('puppet', 'server_puppetserver_version'))
    Kafo::Helpers.reset_value(param('puppet', 'server_ruby_load_paths'))
    Kafo::Helpers.reset_value(param('puppet', 'server_ssl_dir'))
  end

  Kafo::Helpers.log_and_say :info, "Puppet 3 to 4 upgrade param reset, continuing with installation"
end
