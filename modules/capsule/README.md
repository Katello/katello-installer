Puppet Capsule Module
=====================

Wrapper around Katello capsule modules (smart-proxy, Pulp nodes) that
serves as entry point for the configuration. The reason for this
is mainly the logic for setting the certificates properly.

Usage
-----

```

  # Install Katello together with some smart proxy features
  katello-installer --capsule-dns true\
                    --capsule-dns-interface virbr1\
                    --capsule-dns-zone example.com\
                    --capsule-dhcp true\
                    --capsule-dhcp-interface virbr1\
                    --capsule-tftp true\
                    --capsule-puppet true\
                    --capsule-puppetca true
```

License
-------

Copyright 2013 Red Hat, Inc.
GPLv2
