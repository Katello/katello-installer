# Pulp Consumer Params
class pulp::consumer::params {
  $version = 'installed'
  $enable_puppet = false
  $enable_nodes = false
  $enable_rpm = true

  $host = $::fqdn
  $port = 443
  $api_prefix = '/pulp/api'
  $verify_ssl = true
  $ca_path = '/etc/pki/tls/certs/ca-bundle.crt'
  $rsa_server_pub = '/etc/pki/pulp/consumer/server/rsa_pub.key'

  $rsa_key = '/etc/pki/pulp/consumer/rsa.key'
  $rsa_pub = '/etc/pki/pulp/consumer/rsa_pub.key'

  $role = 'consumer'

  $extensions_dir = '/usr/lib/pulp/consumer/extensions'
  $repo_file = '/etc/yum.repos.d/pulp.repo'
  $mirror_list_dir = '/etc/yum.repos.d'
  $gpg_keys_dir = '/etc/pki/pulp-gpg-keys'
  $cert_dir = '/etc/pki/pulp/client/repo'
  $id_cert_dir = '/etc/pki/pulp/consumer/'
  $id_cert_filename = 'consumer-cert.pem'

  $reboot_permit = false
  $reboot_delay = 3

  $logging_filename = '~/.pulp/consumer.log'
  $logging_call_log_filename = '~/.pulp/consumer_server_calls.log'

  $poll_frequency_in_seconds = 1
  $enable_color = true
  $wrap_to_terminal = false
  $wrap_width = 80

  $messaging_scheme = 'tcp'
  $messaging_host = $host
  $messaging_port = 5672
  $messaging_transport = 'qpid'
  $messaging_cacert = undef
  $messaging_clientcert = undef

  $profile_minutes = 240

  $package_profile_enabled = 1
  $package_profile_verbose = 1
}
