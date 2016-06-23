# puppet-squid3

## Overview

Install, enable and configure a Squid 3 http proxy server with its main
configuration file options.

* `squid3` : Main class for the Squid 3 http proxy server.

## Examples

Basic memory caching proxy server :

```puppet
include squid3
```

Non-caching multi-homed proxy server :

```puppet
class { '::squid3':
  acl => [
    'country_de myip 192.168.1.1',
    'country_fr myip 192.168.1.2',
    'office src 10.0.0.0/24',
  ],
  http_access => [
    'allow office',
  ],
  cache => [ 'deny all' ],
  via => 'off',
  tcp_outgoing_address => [
    '192.168.1.1 country_de',
    '192.168.1.2 country_fr',
  ],
  server_persistent_connections => 'off',
}
```

## Caveats

Upgrading Squid3 from version 3.2 to 3.3 breaks the configuration file to fix :

```puppet
class { '::squid3':
  use_deprecated_opts => false
}
```

