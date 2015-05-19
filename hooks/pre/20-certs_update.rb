require 'fileutils'

SSL_BUILD_DIR = '/root/ssl-build/'
CHECK_SCRIPT  = File.expand_path('../../../bin/katello-certs-check', __FILE__)

def error(message)
  logger.error message
  say message
  exit 101
end

def mark_for_update(cert_name, hostname = nil)
  path = File.join(*[SSL_BUILD_DIR, hostname, cert_name].compact)
  puts "Marking certificate #{path} for update"
  if app_value(:noop)
    puts "skipping in noop mode"
  else
    FileUtils.touch("#{path}.update")
  end
end

ca_file   = param('certs', 'server_ca_cert').value
cert_file = param('certs', 'server_cert').value
key_file  = param('certs', 'server_key').value
req_file  = param('certs', 'server_cert_req').value

if app_value('certs_update_server_ca') && !Kafo::Helpers.module_enabled?(@kafo, 'katello')
  error "--certs-update-server-ca needs to be used with katello-installer"
end

if param('capsule_certs', 'capsule_fqdn')
  hostname = param('capsule_certs', 'capsule_fqdn').value
else
  hostname = param('certs', 'node_fqdn').value
end

if app_value('certs_update_server')
  mark_for_update("#{hostname}-apache", hostname)
  mark_for_update("#{hostname}-foreman-proxy", hostname)
end

if app_value('certs_update_all') || app_value('certs_update_default_ca')
  all_cert_names = Dir.glob(File.join(SSL_BUILD_DIR, hostname, '*.noarch.rpm')).map do |rpm|
    File.basename(rpm).sub(/-1\.0-\d+\.noarch\.rpm/, '')
  end.uniq

  all_cert_names.each do |cert_name|
    mark_for_update(cert_name, hostname)
  end
end

if app_value('certs_update_server_ca')
  mark_for_update('katello-server-ca')
end

if !app_value('certs_skip_check') &&
       cert_file.to_s != "" &&
       (app_value('certs_update_server_ca') || app_value('certs_update_server'))
  check_cmd = %{#{CHECK_SCRIPT} -c "#{cert_file}" -r "#{req_file}" -k "#{key_file}" -b "#{ca_file}"}
  output = `#{check_cmd} 2>&1`
  unless $?.success?
    error "Command '#{check_cmd}' exited with #{$?.exitstatus}:\n #{output}"
  end
end
