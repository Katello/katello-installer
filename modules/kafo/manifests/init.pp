class kafo (
  $master_fqdn = undef,
  $pulp = true
  ) {

  class { 'certs': generate => false, deploy   => true }

  if $pulp {
    class { 'apache::ssl': }
  }

  if $pulp {
    class { 'pulp': }
    class { 'pulp::child':
      parent_fqdn => $master_fqdn,
    }
  }
}
