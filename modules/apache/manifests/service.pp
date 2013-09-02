class apache::service {
  $http_service = $::osfamily ? {
    'Debian' => 'apache2',
    default  => 'httpd',
  }

  service { $http_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => 'httpd',
    subscribe  => Package['httpd']
  }

  exec { 'reload-apache':
    command             => "service ${http_service} reload",
    path                => ["/sbin", "/usr/sbin", "/bin", "/usr/bin"],
    onlyif              => $::operatingsystem ? {
      /(Debian|Ubuntu)/ => '/usr/sbin/apache2ctl -t',
      default           => '/usr/sbin/apachectl -t',
    },
    require     => Service[$http_service],
    refreshonly => true,
  }

}
