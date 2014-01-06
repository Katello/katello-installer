class qpid::certs (
  $hostname = $::certs::node_fqdn,
  $generate = $::certs::generate,
  $regenerate = $::certs::regenerate,
  $deploy   = $::certs::deploy,
  $ca       = $::certs::default_ca
  ){

  if $ssl {

    cert { "${qpid::certs::hostname}-qpid-broker":
      hostname      => $qpid::certs::hostname,
      ensure        => present,
      country       => $::certs::country,
      state         => $::certs::state,
      city          => $::certs::sity,
      org           => $::certs::org,
      org_unit      => $::certs::org_unit,
      expiration    => $::certs::expiration,
      ca            => $ca,
      generate      => $generate,
      regenerate    => $regenerate,
      deploy        => $deploy,
    }

    if $deploy {
      # the nssdb nonsense here
    }

  }

}
