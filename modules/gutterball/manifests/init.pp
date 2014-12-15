# Install and Configure gutterball
#
# == Parameters:
#
# $gutterball_conf_file::   Gutterball configuration file
#                           default '/etc/gutterball/gutterball_conf_file'
#
# $db_user::                The Gutterball database username;
#                           default 'gutterball'
#
# $db_password::            The Gutterball database password;
#                           default 'redhat'
#
# $tomcat::                 The system tomcat to use, tomcat6 on RHEL6 and tomcat on most Fedoras
#
# $keystore_password::      Password to keystore and trutstore
#
class gutterball (
  $gutterball_conf_file = $gutterball::params::gutterball_conf_file,
  $dbuser = $gutterball::params::dbuser,
  $dbpassword = $gutterball::params::dbpassword,
  $keystore_password = $gutterball::params::keystore_password,
  $tomcat = $gutterball::params::tomcat,
) inherits gutterball::params {


  # TODO
  class { 'gutterball::install': } ~>
  class { 'gutterball::config':
    keystore_password => $keystore_password
  } ~>
  class { 'gutterball::database': } ~>
  class { 'gutterball::service': } ~>
  Class['gutterball']

}
