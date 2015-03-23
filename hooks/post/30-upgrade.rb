if app_value(:upgrade)
  if Kafo::Helpers.module_enabled?(@kafo, 'katello')
    noop = app_value(:noop) ? ' (noop)' : ''

    Kafo::Helpers.log_and_say :info, "Upgrade Step: Restarting services...#{noop}"
    Kafo::Helpers.execute('katello-service restart') unless app_value(:noop)

    Kafo::Helpers.log_and_say :info, "Upgrade Step: db:seed...#{noop}"
    Kafo::Helpers.execute('foreman-rake db:seed') unless app_value(:noop)

    Kafo::Helpers.log_and_say :info, "Upgrade Step: Running errata import task (this may take a while)...#{noop}"
    Kafo::Helpers.execute('foreman-rake katello:upgrades:2.1:import_errata') unless app_value(:noop)
  end

  if [0,2].include? @kafo.exit_code
    Kafo::Helpers.log_and_say :info, 'Katello upgrade completed!'
  end
end
