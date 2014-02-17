# Candlepin params
class candlepin::params {

  case $::operatingsystem {
    'Fedora': {
      $tomcat = 'tomcat'
    }
    default: {
      $tomcat = 'tomcat6'
    }
  }

  $db_user = 'candlepin'
  $db_name = 'candlepin'

  # this comes from keystore
  $db_password = random_password(32)

  # where to store output from cpsetup execution
  $log_dir  = '/var/log/candlepin'

  $crl_file = '/var/lib/candlepin/candlepin-crl.crl'

  $oauth_key = 'candlepin'
  $oauth_secret = 'candlepin'

  $thumbslug_oauth_key = 'thumbslug'
  $thumbslug_oauth_secret = 'thumbslug'

  $user_groups = []

  $env_filtering_enabled = true
  $thumbslug_enabled = false

  $deployment_url = 'candlepin'

}
