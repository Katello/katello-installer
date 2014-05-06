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
    $oauth_secret          = 'secret',
    $ssl_cert              = '/etc/pki/pulp/ssl_apache.crt',
    $ssl_key               = '/etc/pki/pulp/ssl_apache.key'
  ) {

  if ! $parent_fqdn { fail('$parent_fqdn has to be specified') }

  class { 'pulp::child::install': } ~>

  class { 'pulp::child::config': } ~>

  class { 'pulp::child::service': }
}
