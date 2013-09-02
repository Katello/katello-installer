class pulp::child (
    $parent_fqdn = undef,
    $parent_qpid_scheme = 'ssl',
    $parent_qpid_port   = '5671',
    $consumer_bundle = '/etc/pki/pulp/consumer/parent_bundle.crt'
  ) {

  if ! $parent_fqdn { fail('$parent_fqdn has to be specified') }

  class { 'pulp::child::install': } ~>

  class { 'pulp::child::certs':
    notify => [Class['pulp::config'], Service[httpd], Class['pulp::child::service']]
  } ~>

  class { 'pulp::child::config': } ~>

  class { 'pulp::child::service': }
}
