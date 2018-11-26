{
  'foreman_proxy_certs' => ['certs_tar'],
  'foreman_proxy_content' => ['certs_tar'],
}.each do |mod, param_names|
  param_names.each do |param_name|
    answer = param(mod, param_name)
    answer.value = File.expand_path(answer.value) if answer && answer.value
  end
end
