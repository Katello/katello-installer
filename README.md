# Katello Installer

A set of tools to properly configure Katello with Foreman in production and development.

## Production Usage

```
$ yum install -y katello-installer

# install Katello with Foreman and smarty proxy with Puppet and Puppetca
$ katello-installer
```

### Production Examples

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

## Development Usage

```
$ yum install -y katello-installer

# install Katello with Foreman from git
$ katello-devel-installer
```

### Development Examples

Install with custom user

```
katello-devel-installer --katello-devel-user testuser --certs-group testuser --katello-deployment-dir /home/testuser
```

Install without RVM

```
katello-devel-installer --katello-use-rvm false
```

## Updating packages

This repository uses the gems librarian and librarian-puppet to handle the dependent 
puppet modules. To update the modules, install the 2 gems and run `rel-eng/librarian-update`, 
which updates all the modules. `tito` is used for doing the releases.
