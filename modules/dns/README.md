[![Puppet Forge](http://img.shields.io/puppetforge/v/theforeman/dns.svg)](https://forge.puppetlabs.com/theforeman/dns)
[![Build Status](https://travis-ci.org/theforeman/puppet-dns.svg?branch=master)](https://travis-ci.org/theforeman/puppet-dns)

# DNS module for Puppet

Installs and manages an ISC BIND DNS server with basic zones, primarily for The
Foreman.

# Usage

Include the top level `dns` class to fully configure the service.

    include ::dns

A key is set up to allow dynamic DNS updates, stored in rndc.key.  This is used
by Foreman's smart proxy to add and remove records on the fly.

Zones can be created with the `dns::zone` resource:

    dns::zone { 'example.com': }

Slaves can also be configured by setting `allow_transfer` in the master's zone
and setting `zonetype => 'slave'` in the slave's zone.

# Credits

Based on zleslie-dns, with a lot of the guts ripped out. Thanks
to zleslie for the original work

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

See the CONTRIBUTING.md file for much more information.

# More info

See http://theforeman.org or at #theforeman irc channel on freenode

Copyright (c) 2010-2015 Foreman developers and Zach Leslie

Except where specified in provided modules, this program and entire
repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
