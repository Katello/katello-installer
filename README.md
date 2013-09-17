Katello Node Installer
=======================

A set of tools to properly configure katello node.

The installation consists of two parts:

1. certificates preparation on the master

   In this phase the certificates are generated for the subsystems to
   work properly. The resulting set of certificates is saved into a
   tar archive or pushed into Katello protected repository.

2. the installation of the node itself

   Installing and setting up all the requirements for the node to work
   properly. The certificates generate in step 1. are used, either by
   providing the --certs-tar argument, or using the packages from the
   Katello protected repo.

Usage
-----

*On the master:*

```
$ yum install -y node-installer katello-certs-tools
$ node-certs-generate \
    --child-fqdn node.example.com \
    --katello-user admin\
    --katello-password admin\
    --katello-activation-key node-installer
```

This generates all the certificates for the node and uploads it into
Katello repository (by default "Katello Infrastrucuture" organization,
"node-installer" provider, "node-certs" product and "$child-fqdn"
repo). The optional --katello-activation-key option creates an
activation key that subscribes the node to the product so that the
certs are available for the node just after registration.

On the node:

```
# the node has to be registered to Katello prior the installation
rpm -ivh http://master.example.com/pub/candlepin-cert-consumer-latest.noarch.rpm
subscription-manager register\
  --org "Katello Infrastructure" --activation_key node-installer

yum install -y node-installer
node-install --parent-fqdn master.example.com
```

The `node-installer` takes parameters to determine what features should
be set for the node: `--pulp`, `--dns`, `--dhcp`, `--tftp`, `--puppet`
and `--puppetca. See `--help` for more details.

Examples
--------

```
# Install all the node services

node-install  --parent-fqdn katello.example.com\
              --pulp true\
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
  and use certs from tar file

node-install  --parent-fqdn katello.example.com\
              --pulp true\
              --certs-tar ~/certs.tar.gz\
              --verbose

# Install only DNS with smart proxy

node-install  --parent-fqdn katello.example.com\
              --dns true\
              --dns-forwarders 8.8.8.8 --dns-forwarders  8.8.4.4\
              --dns-interface virbr1\
              --register-in-foreman true\
              --oauth-consumer-secret "foreman"\
              --oauth-consumer-secret "mysecretoauthkey"\
              --verbose

```
