Katello Installer
=======================

A set of tools to properly configure Katello with Foreman.

Usage
-----

```
$ yum install -y katello-installer

# install Katello with Foreman and smarty proxy with Puppet and Puppetca
$ katello-installer
```

Examples
--------

```
# Install also provisioning-related services

katello-installer --capsule-dns true\
                  --capsule-dns-forwarders 8.8.8.8 --dns-forwarders  8.8.4.4\
                  --capsule-dns-interface virbr1\
                  --capsule-dhcp true\
                  --capsule-dhcp-interface virbr1\
                  --capsule-tftp true\
                  --capsule-puppet true\
                  --capsule-puppetca true

# Install only DNS with smart proxy

katello-installer --capsule-dns true\
                  --capsule-dns-forwarders 8.8.8.8 --dns-forwarders  8.8.4.4\
                  --capsule-dns-interface virbr1\
                  --capsule-puppet false\
                  --capsule-puppetca false
```
