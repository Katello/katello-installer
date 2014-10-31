# Candlepin installation packages
class candlepin::install {

  package { ['candlepin', "candlepin-${candlepin::tomcat}"]:
    ensure => $candlepin::version
  }

}
