# Candlepin params
class candlepin::params {
  $tomcat = $::osfamily ? {
    /^(RedHat|Linux)/ => $::operatingsystem ? {
      'Fedora'  => 'tomcat',
      default   => $::operatingsystemrelease ? {
        /^7\./  => 'tomcat',
        default => 'tomcat6'
      }
    },
    default => 'tomcat'
  }

  $ssl_port = 8443

  $manage_db = true
  $db_type = 'postgresql'
  $db_host = 'localhost'
  $db_user = 'candlepin'
  $db_name = 'candlepin'
  $db_port = undef

  # this comes from keystore
  $db_password = cache_data('foreman_cache_data', 'candlepin_db_password', random_password(32))

  $keystore_file = 'conf/keystore'
  $keystore_password = undef
  $keystore_type = 'PKCS12'
  $truststore_file = 'conf/keystore'
  $truststore_password = undef

  $amq_enable = false
  $amqp_keystore_password = undef
  $amqp_truststore_password = undef
  $amqp_keystore = '/etc/candlepin/certs/amqp/candlepin.jks'
  $amqp_truststore = '/etc/candlepin/certs/amqp/candlepin.truststore'

  # where to store output from cpsetup execution
  $log_dir  = '/var/log/candlepin'

  $crl_file = '/var/lib/candlepin/candlepin-crl.crl'

  $oauth_key = 'candlepin'
  $oauth_secret = 'candlepin'

  $thumbslug_oauth_key = 'thumbslug'
  $thumbslug_oauth_secret = 'thumbslug'

  $ca_key = '/etc/candlepin/certs/candlepin-ca.key'
  $ca_cert = '/etc/candlepin/certs/candlepin-ca.crt'
  $ca_key_password = undef

  $user_groups = []

  $env_filtering_enabled = true
  $thumbslug_enabled = false

  $deployment_url = 'candlepin'

  $qpid_ssl_port = 5671

  $version = 'present'
  $wget_version = 'present'
  $run_init = true
  $adapter_module = undef
  $enable_hbm2ddl_validate = true

  $enable_basic_auth = true
  $enable_trusted_auth = false

  $consumer_system_name_pattern = undef
}
