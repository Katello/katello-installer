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

katello-installer --capsule-dns            "true"\
                  --capsule-dns-forwarders "8.8.8.8"
                  --capsule-dns-forwarders "8.8.4.4"\
                  --capsule-dns-interface  "virbr1"\
                  --capsule-dns-zone       "example.com"\
                  --capsule-dhcp           "true"\
                  --capsule-dhcp-interface "virbr1"\
                  --capsule-tftp           "true"\
                  --capsule-puppet         "true"\
                  --capsule-puppetca       "true"

# Install only DNS with smart proxy

katello-installer --capsule-dns            "true"\
                  --capsule-dns-forwarders "8.8.8.8"
                  --capsule-dns-forwarders "8.8.4.4"\
                  --capsule-dns-interface  "virbr1"\
                  --capsule-dns-zone       "example.com"\
                  --capsule-puppet         "false"\
                  --capsule-puppetca       "false"

# Generate certificates for installing capsule on another system
capsule-certs-generate --capsule-fqdn "mycapsule.example.com"\
                       --certs-tar    "~/mycapsule.example.com-certs.tar"

# Copy the ~/mycapsule.example.com-certs.tar to the capsule system
# register the system to Katello and run:
capsule-installer --parent-fqdn          "master.example.com"\
                  --register-in-foreman  "true"\
                  --foreman-oauth-key    "foreman_oauth_key"\
                  --foreman-oauth-secret "foreman_oauth_secret"\
                  --pulp-oauth-secret    "pulp_oauth_secret"\
                  --certs-tar            "/root/mycapsule.exampe.com-certs.tar"\
                  --puppet               "true"\
                  --puppetca             "true"\
                  --pulp                 "true"\
                  --dns                  "true"\
                  --dns-forwarders       "8.8.8.8"\
                  --dns-forwarders       "8.8.4.4"\
                  --dns-interface        "virbr1"\
                  --dns-zone             "example.com"\
                  --dhcp                 "true"\
                  --dhcp-interface       "virbr1"\
                  --tftp                 "true"\
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

## Filing and Fixing Issues

All issues are tracked using (Redmine)[http://projects.theforeman.org/projects/katello/issues]. There are two types of issues that may arise:

  * A bug within an individual module
  * A bug within the hooks or scripts of the installer

### Module Bugs

For bugs found within an individual module, the following needs doing:

  * A bug should be filed under the Katello Installer category
  * Fix and open a PR against the module itself, in some cases this may be a module own by the Katello, or the Foreman or may be a third party module (see the Puppetfile for a list of modules and their locations)
  * Once the fix is available within the module, follow the *Updating Packages* section and open a PR with the updates

### Installer Bugs

For bugs found within the hooks, config, answer or script files, please do the following:

  * Open a Redmine issues describing the problem
  * Fix and open a PR against the installer

## Updating Packages

This repository uses the gems librarian and librarian-puppet to handle the dependent
puppet modules. To update all the modules and automatically commit the result:

```
gem install librarian librarian-puppet puppet
rel-eng/librarian-update
```

`tito` is used for doing the releases.
