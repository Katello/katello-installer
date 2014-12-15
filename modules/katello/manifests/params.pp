# Katello Default Params
class katello::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          $scl_prefix = ''
          $scl_root = ''
        }
        default: {
          $scl_prefix = 'ruby193-'
          $scl_root = '/opt/rh/ruby193/root'
        }
      }

      $package_names = ['katello', "${scl_prefix}rubygem-katello"]
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  $rhsm_url = '/rhsm'
  $deployment_url = '/katello'

  if file_exists('/usr/sbin/tomcat') and !file_exists('/usr/sbin/tomcat6') {
    $tomcat = 'tomcat'
  }
  else {
    $tomcat = 'tomcat6'
  }

  # HTTP Proxy settings (currently used by pulp)
  $proxy_url = undef
  $proxy_port = undef
  $proxy_username = undef
  $proxy_password = undef

  # cdn ssl settings
  $cdn_ssl_version = undef

  # system settings
  $user = 'foreman'
  $group = 'foreman'
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
  $oauth_token_file = 'katello_oauth_secret'
  $oauth_secret = cache_data($oauth_token_file, random_password(32))

  $post_sync_token = cache_data('post_sync_token', random_password(32))

  # Subsystems settings
  $candlepin_url = 'https://localhost:8443/candlepin'
  $pulp_url      = subsystem_url('pulp/api/v2/')
  $foreman_url   = subsystem_url('foreman')

  $gutterball = true

  # database reinitialization flag
  $reset_data = 'NONE'

  # Delete this from configuration check
  $use_foreman = false
  $ldap_roles = false
  $validate_ldap = false

  $use_passenger = true

  $qpid_url = "amqp:ssl:${::fqdn}:5671"
  $candlepin_event_queue = 'katello_event_queue'
}
