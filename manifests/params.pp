# Candlepin params
class candlepin::params {

  if file_exists('/usr/sbin/tomcat') and file_exists('/usr/sbin/tomcat6') {
    $tomcat = 'tomcat'
  }
  else {
    $tomcat = 'tomcat6'
  }

  $db_user = 'candlepin'
  $db_name = 'candlepin'

  # this comes from keystore
  $db_pass = 'candlepin'

  # where to store output from cpsetup execution
  $log_dir  = '/var/log/candlepin'
  $cpdb_log = "${log_dir}/cpdb.log"

  $crl_file = '/var/lib/candlepin/candlepin-crl.crl'

  $oauth_key = 'candlepin'
  $oauth_secret = 'candlepin'

  $thumbslug_oauth_key = 'thumbslug'
  $thumbslug_oauth_secret = 'thumbslug'

  $user_groups = []

  # database reinitialization flag
  $reset_data = 'NONE'

  $env_filtering_enabled = true
  $thumbslug_enabled = false

  $deployment_url = 'candlepin'

}
