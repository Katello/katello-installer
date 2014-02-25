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
                  --capsule-dns-forwarders 8.8.8.8 --capsule-dns-forwarders  8.8.4.4\
                  --capsule-dns-interface virbr1\
                  --capsule-dns-zone example.com\
                  --capsule-dhcp true\
                  --capsule-dhcp-interface virbr1\
                  --capsule-tftp true\
                  --capsule-puppet true\
                  --capsule-puppetca true

# Install only DNS with smart proxy

katello-installer --capsule-dns true\
                  --capsule-dns-forwarders 8.8.8.8 --capsule-dns-forwarders  8.8.4.4\
                  --capsule-dns-interface virbr1\
                  --capsule-dns-zone example.com\
                  --capsule-puppet false\
                  --capsule-puppetca false
```

Updating packages
-----------------

This repository uses librarian to handle the dependent puppet modules.
To update the modules, run `rel-eng/librarian-update`, which updates
all the modules. `tito` is used for doing the releases.
