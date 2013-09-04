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
