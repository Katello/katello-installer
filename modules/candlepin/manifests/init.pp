# Install and Configure candlepin
#
# == Parameters:
#
# $oauth_key::              The oauth key for talking to the candlepin API;
#                           default 'candlepin'
#
# $oauth_secret::           The oauth secret for talking to the candlepin API;
#                           default 'candlepin'
#
# $db_name::                The name of the Candlepin database;
#                           default 'candlepin'
#
# $db_user::                The Candlepin database username;
#                           default 'candlepin'
#
# $db_password::            The Candlepin database password;
#                           default 'candlepin'
#
# $tomcat::                 The system tomcat to use, tomcat6 on RHEL6 and tomcat on most Fedoras
#
# $crl_file::               The Certificate Revocation File for Candlepin
#
# $user_groups::            The user groups for the Candlepin tomcat user
#
# $log_dir::                Directory for Candlepin logs;
#                           default '/var/log/candlepin'
#
# $deployment_url::         The root URL to deploy the Web and API URLs at
#
# $weburl::                 The Candlepin Web URL which is configurable via the deployment_url
#
# $apiurl::                 The Candlepin API URL which is configurable via the deployment_url
#
# $env_filtering_enabled::  default 'true'
#
# $thumbslug_enabled::      If using Thumbslug; default 'false'
#
# $thumbslug_oauth_key::    The oauth key for talking to Thumbslug
#
# $thumbslug_oauth_secret:: The oauth secret for talking to Thumbslug
#
# $keystore_password::      Password for keystore being used with Tomcat
#
# $ca_key::                 CA key file to use
#
# $ca_cert::                CA certificate file to use
#
# $ca_key_password::        CA key password
#
class candlepin (

  $db_name     = $candlepin::params::db_name,
  $db_user     = $candlepin::params::db_user,
  $db_password = $candlepin::params::db_password,

  $tomcat = $candlepin::params::tomcat,

  $crl_file = $candlepin::params::crl_file,

  $user_groups = $candlepin::params::user_groups,

  $log_dir = $candlepin::params::log_dir,

  $oauth_key = $candlepin::params::oauth_key,
  $oauth_secret = $candlepin::params::oauth_secret,

  $deployment_url = $candlepin::params::deployment_url,

  $env_filtering_enabled = $candlepin::params::env_filtering_enabled,

  $thumbslug_enabled = $candlepin::params::thumbslug_enabled,
  $thumbslug_oauth_key = $candlepin::params::thumbslug_oauth_key,
  $thumbslug_oauth_secret = $candlepin::params::thumbslug_oauth_secret,

  $keystore_password = undef,

  $ca_key = $candlepin::params::ca_key,
  $ca_cert = $candlepin::params::ca_crt,
  $ca_key_password = $candlepin::params::ca_key_password

  ) inherits candlepin::params {

  $weburl = "https://${::fqdn}/${candlepin::deployment_url}/distributors?uuid="
  $apiurl = "https://${::fqdn}/${candlepin::deployment_url}/api/distributors/"

  class { 'candlepin::install': } ~>
  class { 'candlepin::config': } ~>
  class { 'candlepin::database': } ~>
  class { 'candlepin::service': } ~>
  Class['candlepin']

}
