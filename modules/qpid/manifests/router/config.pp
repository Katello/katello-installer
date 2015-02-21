# == Class: qpid::router::configure
#
# Handles Qpid Dispatch Router configuration
#
class qpid::router::config {

  concat_build {'qdrouter':
    order  => [
                '*header*.conf',
                '*ssl*.conf',
                '*connector*.conf',
                '*link_route_pattern*.conf',
                '*listener*.conf',
                '*footer*.conf',
              ],
  }

  concat_fragment {'qdrouter+header.conf':
    content => template('qpid/router/header.conf.erb'),
  }

  concat_fragment {'qdrouter+footer.conf':
    content => template('qpid/router/footer.conf.erb'),
  }

  file { $qpid::router::config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => concat_output('qdrouter'),
    require => Concat_build['qdrouter'],
  }
}
