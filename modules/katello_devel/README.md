####Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with katello_devel](#setup)
    * [What katello_devel affects](#what-katello_devel-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with katello_devel](#beginning-with-katello_devel)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module is designed to setup a Katello development environment for developing Katello or Foreman in the context of each other.

##Setup

###What katello_devel affects

* Installs Katello and Foreman from git
* Provides an HTTPS server and proxy to local Rails server for easy use of subscription-manager
* Uses RVM to provide isolated gem environment

###Beginning with katello_devel

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

##Usage

Please see https://github.com/Katello/katello-installer#development-examples

##Reference

##Limitations

* EL6 (RHEL6 / CentOS 6)
* EL7 (RHEL7 / CentOS 7)

##Development

See the CONTRIBUTING guide for steps on how to make a change and get it accepted upstream.

