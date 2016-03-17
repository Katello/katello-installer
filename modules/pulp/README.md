[![Puppet Forge](http://img.shields.io/puppetforge/v/katello/pulp.svg)](https://forge.puppetlabs.com/katello/pulp)
[![Build Status](https://travis-ci.org/Katello/puppet-pulp.svg?branch=master)](https://travis-ci.org/Katello/puppet-pulp)
####Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with pulp](#setup)
    * [What pulp affects](#what-pulp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pulp](#beginning-with-pulp)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module is designed to setup a Pulp master or node.

##Setup

###What pulp affects

* Installs and configures a Pulp master or node

###Beginning with pulp

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

##Usage

##Reference

##Limitations

* EL6,7 (RHEL6,7 / CentOS 6,7)
* Requires Pulp 2.7.0 or higher.

##Pulp consumer

###Installation:

    include pulp::consumer

###Register consumer:
The provider doesn't support yet updating notes or description.

    pulp_register{$::fqdn:
    	user => 'admin',
    	pass => 'admin'
    }

##Development

See the CONTRIBUTING guide for steps on how to make a change and get it accepted upstream.
