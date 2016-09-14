define certs::rhsm_reconfigure_script($ca_cert, $server_ca_cert) {

  concat { $title:
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  concat::fragment { "${title}+script_start":
    target  => $title,
    content => "#!/bin/bash\n\n",
    order   => '01',
  }

  concat::fragment { "${title}+default_ca_data":
    target  => $title,
    content => "read -r -d '' KATELLO_DEFAULT_CA_DATA << EOM\n",
    order   => '02',
  }

  concat::fragment { "${title}+ca_cert":
    target => $title,
    source => $ca_cert,
    order  => '03',
  }

  concat::fragment { "${title}+end_ca_cert":
    target  => $title,
    content => "EOM\n\n",
    order   => '04',
  }

  concat::fragment { "${title}+server_ca_data":
    target  => $title,
    content => "read -r -d '' KATELLO_SERVER_CA_DATA << EOM\n",
    order   => '05',
  }

  concat::fragment { "${title}+server_ca_cert":
    target => $title,
    source => $server_ca_cert,
    order  => '06',
  }

  concat::fragment { "${title}+end_server_ca_cert":
    target  => $title,
    content => "EOM\n\n",
    order   => '07',
  }

  concat::fragment { "${title}+reconfigure":
    target  => $title,
    content => template('certs/rhsm-katello-reconfigure.erb'),
    order   => '10',
  }

}
