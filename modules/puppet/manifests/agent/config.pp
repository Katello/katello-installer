# Puppet agent configuration
class puppet::agent::config inherits puppet::config {
  concat::fragment { 'puppet.conf+20-agent':
    target  => "${::puppet::dir}/puppet.conf",
    content => template($puppet::agent_template),
    order   => '20',
  }

  if $::puppet::runmode == 'service' {
    $should_start = 'yes'
  } else {
    $should_start = 'no'
  }

  if $::osfamily == 'Debian' {
    augeas {'puppet::set_start':
      context => '/files/etc/default/puppet',
      changes => "set START ${should_start}",
      incl    => '/etc/default/puppet',
      lens    => 'Shellvars.lns',
    }
    if $::puppet::remove_lock {
      file {'/var/lib/puppet/state/agent_disabled.lock':
        ensure => absent,
      }
    }
  }
}
