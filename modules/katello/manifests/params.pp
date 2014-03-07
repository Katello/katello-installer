# Katello Default Params
class katello::params {

  if ($::operatingsystem == 'RedHat' or $::operatingsystem == 'CentOS'){
    $scl_prefix = 'ruby193-'
    $scl_root = '/opt/rh/ruby193/root'
  } else {
    $scl_prefix = ''
    $scl_root = ''
  }

  $deployment_url = '/katello'

  if file_exists('/usr/sbin/tomcat') and !file_exists('/usr/sbin/tomcat6') {
    $tomcat = 'tomcat'
  }
  else {
    $tomcat = 'tomcat6'
  }

  case $deployment_url {
    '/katello': {
      $deployment = 'katello'
    }
    '/headpin': {
      $deployment = 'headpin'
    }
    default : {
      $deployment = 'katello'
    }
  }

  # HTTP Proxy settings (currently used by pulp)
  $proxy_url = 'NONE'
  $proxy_port = 'NONE'
  $proxy_user = 'NONE'
  $proxy_pass = 'NONE'

  # system settings
  $user_groups = 'foreman'
  $config_dir  = '/etc/foreman/plugins'
  $log_dir     = '/var/log/foreman/plugins'

  # sysconfig settings
  $job_workers = 1

  # OAUTH settings
  $oauth_key = 'katello'

  # we set foreman oauth key to foreman, so that katello knows where the call
  # comes from and can find the rigth secret. This way only one key-secret pair
  # is needed to be mainained for duplex communication.
  $foreman_oauth_key = 'foreman'
  $oauth_token_file = 'oauth_token-file'
  $oauth_secret = cache_data($oauth_token_file, random_password(32))

  $post_sync_token_file = '/etc/katello/post_sync_token'
  $post_sync_token = find_or_create_password($post_sync_token_file)

  # Subsystems settings
  $candlepin_url = 'https://localhost:8443/candlepin'
  $pulp_url      = subsystem_url('pulp/api/v2/')
  $foreman_url   = subsystem_url('foreman')

  # database reinitialization flag
  $reset_data = 'NONE'

  # Delete this from configuration check
  $use_foreman = false
  $ldap_roles = false
  $validate_ldap = false
}
