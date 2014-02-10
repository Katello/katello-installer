# Katello Default Params
class katello::params {

  if ($::operatingsystem == 'RedHat' or $::operatingsystem == 'CentOS'){
    $scl_prefix = 'ruby193-'
    $scl_root = '/opt/rh/ruby193/root'
  } else {
    $scl_prefix = ''
    $scl_root = ''
  }

  # First User and Org settings
  $user_name = 'admin'
  $user_pass = 'changeme'
  $user_email = 'root@localhost'
  $org_name  = 'ACME_Corporation'

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
  $host        = ''
  $user        = 'katello'
  $group       = 'katello'
  $user_groups = 'foreman'
  $config_dir  = '/etc/katello'
  $katello_dir = '/usr/share/katello'
  $environment = 'production'
  $log_dir     = '/var/log/katello'
  $log_base    = '/var/log/katello'
  $configure_log_base = "${log_base}/katello-install"
  $db_env_log  = "${configure_log_base}/db_env.log"
  $migrate_log = "${configure_log_base}/db_migrate.log"
  $seed_log    = "${configure_log_base}/db_seed.log"

  # katello upgrade settings
  $katello_upgrade_scripts_dir  = '/usr/share/katello/install/upgrade-scripts'
  $katello_upgrade_history_file = '/var/lib/katello/upgrade-history'

  # SSL settings
  $ssl_certificate_file     = '/etc/candlepin/certs/candlepin-ca.crt'
  $ssl_certificate_key_file = '/etc/candlepin/certs/candlepin-ca.key'
  $ssl_certificate_ca_file  = $ssl_certificate_file

  # sysconfig settings
  $job_workers = 1

  # OAUTH settings
  $oauth_key    = 'katello'

  # we set foreman oauth key to foreman, so that katello knows where the call
  # comes from and can find the rigth secret. This way only one key-secret pair
  # is needed to be mainained for duplex communication.
  $foreman_oauth_key    = 'foreman'
  $oauth_token_file = '/etc/katello/oauth_token-file'
  $oauth_secret = find_or_create_password($oauth_token_file)

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
