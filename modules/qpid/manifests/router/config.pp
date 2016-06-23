# == Class: qpid::router::configure
#
# Handles Qpid Dispatch Router configuration
#
class qpid::router::config {

  concat::fragment {'qdrouter+header.conf':
    target  => $qpid::router::config_file,
    content => template('qpid/router/header.conf.erb'),
    order   => '01',
  }

  concat::fragment {'qdrouter+footer.conf':
    target  => $qpid::router::config_file,
    content => template('qpid/router/footer.conf.erb'),
    order   => '100',
  }

  concat { $qpid::router::config_file:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
}
