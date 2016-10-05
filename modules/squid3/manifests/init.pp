# Class: squid3
#
class squid3 (
  # Options are in the same order they appear in squid.conf
  $use_deprecated_opts           = true,
  $use_default_localnet          = true,
  $http_port                     = [ '3128' ],
  $https_port                    = [],
  $acl                           = [],
  $ssl_ports                     = [ '443' ],
  $safe_ports                    = [ '80', '21', '443', '70', '210', '1025-65535', '280', '488', '591', '777', ],
  $http_access                   = [],
  $icp_access                    = [],
  $tcp_outgoing_address          = [],
  $cache_mem                     = '256 MB',
  $cache_dir                     = [],
  $cache                         = [],
  $via                           = 'on',
  $reply_header_access           = [],
  $ignore_expect_100             = 'off',
  $pconn_timeout                 = undef,
  $cache_mgr                     = 'root',
  $forwarded_for                 = 'on',
  $client_persistent_connections = 'on',
  $server_persistent_connections = 'on',
  $maximum_object_size           = '4096 KB',
  $maximum_object_size_in_memory = '512 KB',
  $config_array                  = false,
  $config_hash                   = false,
  $refresh_patterns              = [],
  $template                      = 'long',
  $package_version               = 'installed',
  $package_name                  = $::squid3::params::package_name,
  $service_ensure                = 'running',
  $service_enable                = $::squid3::params::service_enable,
  $service_name                  = $::squid3::params::service_name,
  $access_log                    = $::squid3::params::access_log,
  $cache_log                     = $::squid3::params::cache_log,
  $cache_store_log               = $::squid3::params::cache_store_log,
  $strip_query_terms             = undef,
) inherits ::squid3::params {

  $use_template = $template ? {
    'short' => 'squid3/squid.conf.short.erb',
    'long'  => 'squid3/squid.conf.long.erb',
    default => $template,
  }

  if ($config_array or $config_hash) and $use_template == 'long' {
    fail('config_array and config_hash do not (yet) work with the "long" template!')
  }

  if $config_array and $config_hash {
    fail('only one of config_array or config_hash can be used')
  }

  package { 'squid3_package':
    ensure => $package_version,
    name   => $package_name,
  }

  service { 'squid3_service':
    ensure    => $service_ensure,
    enable    => $service_enable,
    name      => $service_name,
    restart   => "service ${service_name} reload",
    path      => [ '/sbin', '/usr/sbin', '/usr/local/etc/rc.d' ],
    hasstatus => true,
    require   => Package['squid3_package'],
  }

  case $::osfamily {
    'FreeBSD': { $cmdpath = "/usr/local/sbin" }
    default: { $cmdpath = "/usr/sbin" }
  }

  file { $config_file:
    require      => Package['squid3_package'],
    notify       => Service['squid3_service'],
    content      => template($use_template),
    validate_cmd => "${cmdpath}/${service_name} -k parse -f %",
  }

}
