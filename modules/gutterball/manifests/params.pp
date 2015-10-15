# Gutterball Params
class gutterball::params {
  $gutterball_conf_file = '/etc/gutterball/gutterball.conf'
  $dbuser = 'gutterball'
  $dbpassword = 'gutterball'
  $keystore_password = undef

  $tomcat = $::osfamily ? {
    /^(RedHat|Linux)/ => $::operatingsystem ? {
      'Fedora'  => 'tomcat',
      default   => $::operatingsystemrelease ? {
        /^7\./  => 'tomcat',
        default => 'tomcat6'
      }
    }
  }

}
