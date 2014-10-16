require 'uri'

def error(message)
  say message
  logger.error message
  kafo.class.exit 101
end

proxy_param = param('katello', 'proxy_url')
if proxy_param && proxy_param.value && proxy_param.value.length > 0
  uri = URI(param('katello', 'proxy_url').value)
  unless %w(http https).include?(uri.scheme)
    error "--katello-proxy-url must be a full URI and only supports http or https (e.g. http://proxy.example.com)"
  end
end

