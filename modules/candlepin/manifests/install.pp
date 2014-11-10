# Candlepin installation packages
class candlepin::install {

  package { ['candlepin', "candlepin-${candlepin::tomcat}", 'wget']:
    ensure => $candlepin::version
  }

}
