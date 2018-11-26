# These answers should never be stored
{
  'puppet' => ['server_puppetserver_version', 'server_puppetserver_metrics'],
  'foreman_proxy_certs' => ['certs_tar'],
  'foreman_proxy_content' => ['certs_tar'],
}.each do |mod, param_names|
  param_names.each do |param_name|
    answer = param(mod, param_name)
    answer.value = nil if answer && answer.value
  end
end
