#
# == Class: pulp::child
#
# Install and configure Pulp node
#
class pulp::child (
    $parent_fqdn           = undef,
    $parent_qpid_scheme    = 'ssl',
    $parent_qpid_port      = '5671',
    $oauth_effective_user  = 'admin',
    $oauth_key             = 'key',
    $oauth_secret          = 'secret'
  ) {

  if ! $parent_fqdn { fail('$parent_fqdn has to be specified') }

  class { 'pulp::child::install': } ~>

  class { '::certs::pulp_child':
    notify => [Class['pulp::config'], Service[httpd], Class['pulp::child::service']]
  } ~>

  class { 'pulp::child::config': } ~>

  class { 'pulp::child::service': }
}
