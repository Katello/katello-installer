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

## Data Reset

If you run into an error during the initial installation or wish to reset your installation entirely, the installer provides a reset option. To reset the database and all subsystems:

```
katello-installer --reset
```

To clear all of your on disk Pulp content:

```
katello-installer --clear-pulp-content
```

To clear all Puppet environments on disk:

```
katello-installer --clear-puppet-environments
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

### Certificates

Katello installer comes with a default CA used both for the server SSL
certificates as well as the client certificates used for
authentication of the subservices (pulp, foreman-proxy,
subscription-manager etc.).

#### Custom Server Certificates

**When running katello-installer for the first time:**

```
katello-installer --certs-server-cert ~/path/to/server.crt\
                  --certs-server-cert-req ~/path/to/server.crt.req\
                  --certs-server-key ~/path/to/server.crt.req\
                  --certs-server-ca-cert ~/path/to/cacert.crt
```

Where the `--certs-server-ca-ca-cert` is the CA used for issuing the
server certs (this CA gets distributed to the consumers and capsules).

For the capsule, these options are passed as part of the
`capsule-certs-generate` script:

```
capsule-certs-generate --capsule-fqdn "$CAPSULE"\
                       --certs-tar "~/$CAPSULE-certs.tar"\
                       --server-cert ~/path/to/server.crt\
                       --server-cert-req ~/path/to/server.crt.req\
                       --server-key ~/path/to/server.key\
                       --server-ca-cert ~/cacert.crt
```

The rest of the procedure is identical to the default CA setup.

**Setting custom certificates after katello-installer was already
run.**

The first run of `katello-installer` uses the default CA for both server
and client certificates. To enforce the custom certificates to be
deployed, on needs to set `--certs-update-server` for
updating the CA certificate and `--certs-update-server-ca` because the
server CA changed as well (and new katello-ca-consumer rpm needs to be
regenerated):

```
katello-installer --certs-server-cert ~/path/to/server.crt\
                  --certs-server-cert-req ~/path/to/server.crt.req\
                  --certs-server-key ~/path/to/server.crt.req\
                  --certs-server-ca-cert ~/path/to/cacert.crt\
                  --certs-update-server --certs-update-server-ca
```

After the server CA changes, the new version of the
consumer-ca-consumer rpm needs to be installed on the consumers, as
well as:

```
rpm -Uvh http://katello.example.com/pub/katello-ca-consumer-latest.noarch.rpm
```

When using the custom server CA, the CA needs to be used for
the server certificates on the capsules as well. The certificates for
the capsule are deployed to the capsule through the use of the
`capsule-certs-generate` script (followed by copying the certs tar to
the capsule and running the capsule-installer to refresh the certificates).:

```
capsule-certs-generate --capsule-fqdn "$CAPSULE"\
                       --certs-tar "~/$CAPSULE-certs.tar"\
                       --server-cert ~/path/to/server.crt\
                       --server-cert-req ~/path/to/server.crt.req\
                       --server-key ~/path/to/server.key\
                       --server-ca-cert ~/cacert.crt\
                       --certs-update-server
```

#### Updating Certificates

**On a server**

To regenerate the server certificates when using the default CA or
enforce deploying new certificates for the custom server CA run
the katello-installer with `--certs-update-server` option:

```
katello-installer --certs-update-server
```

To regenerate all the certificates used in the Katello server, there
is a `--certs-update-all`. This will generate and deploy the
certificates as well as restart corresponding services.

**On a capsule**

For updating the certificates on a capsule pass the same
options (either `--certs-update-server` or `--certs-update-all`) to
the `capsule-certs-generate` script. The new certs tar gets generated
that needs to be transferred to the capsule and then
`capsule-installer` needs to be re-run to apply the updates and
restart corresponding services.

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
