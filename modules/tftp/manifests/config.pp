# Configure TFTP
class tftp::config {

  case $::tftp::params::daemon {
    default: {
      file { $::tftp::root:
        ensure => directory,
      }

      if $::osfamily =~ /^(FreeBSD|DragonFly)$/ {
        augeas { 'set root directory':
          context => '/files/etc/rc.conf',
          changes => "set tftpd_flags '\"-s ${::tftp::root}\"'",
        }
      }
    }
    false: {
      include ::xinetd

      xinetd::service { 'tftp':
        port        => '69',
        server      => '/usr/sbin/in.tftpd',
        server_args => "-v -s ${::tftp::root} -m /etc/tftpd.map",
        socket_type => 'dgram',
        protocol    => 'udp',
        cps         => '100 2',
        flags       => 'IPv4',
        per_source  => '11',
      }

      file {'/etc/tftpd.map':
        content => template('tftp/tftpd.map'),
        mode    => '0644',
        notify  => Class['xinetd'],
      }

      file { $::tftp::root:
        ensure => directory,
        notify => Class['xinetd'],
      }
    }
  }
}
