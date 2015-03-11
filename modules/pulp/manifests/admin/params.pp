# Pulp Admin Params
class pulp::admin::params {
  $version            = 'installed'
  $host               = 'localhost'
  $port               = 443
  $api_prefix         = '/pulp/api'
  $verify_ssl         = true
  $ca_path            = '/etc/pki/tls/certs/ca-bundle.crt'
  $upload_chunk_size  = 1048576
  $role               = 'admin'
  $extensions_dir     = '/usr/lib/pulp/admin/extensions'
  $id_cert_dir        = '~/.pulp'
  $id_cert_filename   = 'user-cert.pem'
  $upload_working_dir = '~/.pulp/uploads'
  $log_filename       = '~/.pulp/admin.log'
  $call_log_filename  = '~/.pulp/server_calls.log'
  $poll_frequency_in_seconds = 1
  $enable_color       = true
  $wrap_to_terminal   = false
  $wrap_width         = 80
  $puppet             = false
  $docker             = false
  $nodes              = false
  $python             = false
  $rpm                = false

  $puppet_upload_working_dir = '~/.pulp/puppet-uploads'
  $puppet_upload_chunk_size  = 1048576
}
