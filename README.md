Katello Node Installer
=======================

A set of tools to properly configure katello node.

The installation consists of two parts:

1. certificates preparation on the master

   In this phase the certificates are generated for the subsystems to
   work properly. The resulting set of certificates is saved into a
   tar archive. This archive has to be distributed to the node and it
   will be used in the second step.

2. the installation of the node itself

   Installing and setting up all the requirements for the node to work
   properly. The certificates generate in step 1. are used.

Usage
-----

On the master:

```
$ yum install -y node-installer katello-certs-tools
$ node-certs-generate \
    --child-fqdn node.example.com \
    --certs-tar ~/certs.tar.gz
$ scl ~/certs.tar.gz root@node.example.com:~/certs.tar.gz
```

On the node:

```
# the node has to be registered to Katello prior the installation
rpm -ivh http://master.example.com/pub/candlepin-cert-consumer-latest.noarch.rpm
subscription-manager register --org AMCE_Corporation --env Library

yum install -y node-installer
node-install \
    --parent-fqdn master.example.com \
    --certs-tar ~/certs.tar.gz
```

Both `node-certs-generate` and `node-installer` take parameters to
determine what features should be set for the node. See `--help` for
more details.

The values for `--pulp`, `--dns`, `--dhcp`, `--tftp`, `--puppet` and
`--puppetca` options should be the same for both `node-certs-generate`
and `node-installer` commands for the installation to work properly.

Examples
--------

```
# Install all the node services

node-install  --parent-fqdn katello.example.com\
              --pulp true\
              --certs-tar ~/certs.tar.gz\
              --dns true\
              --dns-forwarders 8.8.8.8 --dns-forwarders  8.8.4.4\
              --dns-interface virbr1\
              --dhcp true\
              --dhcp-interface virbr1\
              --tftp true\
              --puppet true\
              --puppetca true\
              --register-in-foreman true\
              --oauth-consumer-secret "foreman"\
              --oauth-consumer-secret "mysecretoauthkey"\
              --verbose

# Install only pulp node (no Foreman proxy or the network services)

node-install  --parent-fqdn katello.example.com\
              --pulp true\
              --certs-tar ~/certs.tar.gz\
              --dns false --dhcp false --tftp false\
              --puppet false --puppetca false\
              --verbose

# Install only DNS with smart proxy

node-install  --parent-fqdn katello.example.com\
              --dns true\
              --dns-forwarders 8.8.8.8 --dns-forwarders  8.8.4.4\
              --dns-interface virbr1\
              --pulp false --dns false --dhcp false --tftp false\
              --puppet false --puppetca false\
              --register-in-foreman true\
              --oauth-consumer-secret "foreman"\
              --oauth-consumer-secret "mysecretoauthkey"\
              --verbose

```
