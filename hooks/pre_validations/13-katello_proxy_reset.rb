def message_and_exit(message)
  Kafo::Helpers.log_and_say :info, message
  kafo.class.exit 1
end

if app_value(:katello_proxy_reset) && !app_value(:noop)

  if param('katello', 'proxy_url').value && param('katello', 'proxy_password').value
    Kafo::Helpers.log_and_say :info, 'Resetting Katello proxy params...'
    Kafo::Helpers.reset_value(param('katello', 'proxy_url'))
    Kafo::Helpers.reset_value(param('katello', 'proxy_port'))
    Kafo::Helpers.reset_value(param('katello', 'proxy_username'))
    Kafo::Helpers.reset_value(param('katello', 'proxy_password'))
  else message_and_exit('There is no proxy set, exiting')
  end
end
