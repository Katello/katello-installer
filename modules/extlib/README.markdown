[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Build Status](https://img.shields.io/travis/puppet-community/puppet-extlib/master.svg)](https://travis-ci.org/puppet-community/puppet-extlib)

####Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with extlib](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module provides functions that are out of scope out of scope for
[stdlib](https://github.com/puppetlabs/puppetlabs-stdlib). Some of them are
even intristically tied to stdlib.

##Setup

```console
 % puppet module install puppet-extlib
```

##Usage

###resources_deep_merge

- *Type*: rvalue

Returns a [deep-merged](#deep_merge) resource hash (hash of hashes).

*Examples:*

```puppet
    $tcresource_defaults = {
      ensure     => 'present',
      attributes => {
        driverClassName => 'org.postgresql.Driver',
      }
    }

    $tcresources = {
      'app1:jdbc/db1' => {
        attributes => {
          url      => 'jdbc:postgresql://localhost:5432/db1',
          userpass => 'user1:pass1',
        },
      },
      'app2:jdbc/db2' => {
        attributes => {
          url      => 'jdbc:postgresql://localhost:5432/db2',
          userpass => 'user2:pass2',
        },
      }
    }
```

When called as:

```puppet
    $result = resources_deep_merge($tcresources, $tcresource_defaults)
```

will return:

```puppet
    {
     'app1:jdbc/db1' => {
       ensure     => 'present',
       attributes => {
         url      => 'jdbc:postgresql://localhost:5432/db1',
         userpass => 'user1:pass1',
         driverClassName => 'org.postgresql.Driver',
       },
     },
     'app2:jdbc/db2' => {
       ensure     => 'present',
       attributes => {
         url      => 'jdbc:postgresql://localhost:5432/db2',
         userpass => 'user2:pass2',
         driverClassName => 'org.postgresql.Driver',
       },
     }
    }
```

###echo

This function output the variable content and its type to the
debug log. It's similiar to the "notice" function but provides
a better output format useful to trace variable types and values
in the manifests.

```ruby
# examples:
$v1 = 'test'
$v2 = ["1", "2", "3"]
$v3 = {"a"=>"1", "b"=>"2"}
$v4 = true
# $v5 is not defined
$v6 = { "b" => ["1","2","3"] }
$v7 = 12345

echo($v1, 'My string')
echo($v2, 'My array')
echo($v3, 'My hash')
echo($v4, 'My boolean')
echo($v5, 'My undef')
echo($v6, 'My structure')
echo($v7) # no comment here

# debug log output:
# My string (String) "test"
# My array (Array) ["1", "2", "3"]
# My hash (Hash) {"a"=>"1", "b"=>"2"}
# My boolean (TrueClass) true
# My undef (String) ""
# My structure (Hash) {"b"=>["1", "2", "3"]}
# (String) "12345"
```

###cache_data

Retrieves data from a cache file, or creates it with supplied data if the file doesn't exist. Useful for having data that's randomly generated once on the master side (e.g. a password), but then stays the same on subsequent runs. The `cache_data` takes three parameters:

 * namespace: the folder under Puppet's vardir that the data is placed (e.g. mysql becomes /var/lib/puppet/mysql)
 * data_name: the filename to store the data as (e.g. mysql_password becomes /var/lib/puppet/mysql/mysql_password)
 * initial_data: the data to store and cache in the data_name file 

*Examples:*

```
class mymodule::params {

  $password = cache_data('mysql', 'mysql_password', 'this_is_my_password')

}
```

###random_password

Returns a string of arbitrary length that contains randomly selected characters.

*Examples:*

```
Prototype:

    random_password(n)

Where n is a non-negative numeric value that denotes length of the desired password.

Given the following statements:

  $a = 4
  $b = 8
  $c = 16

  notice random_password($a)
  notice random_password($b)
  notice random_password($c)

The result will be as follows:

  notice: Scope(Class[main]): fNDC
  notice: Scope(Class[main]): KcKDLrjR
  notice: Scope(Class[main]): FtvfvkS9j9wXLsd6
```

##Limitations

This module requires puppetlabs-stdlib >=3.2.1, which is when `deep_merge()`
was introduced.

##Development

We highly welcome new contributions to this module, especially those that
include documentation, and rspec tests ;) but will happily guide you through
the process, so, yes, please submit that pull request!

This module uses [blacksmith](https://github.com/maestrodev/puppet-blacksmith)
for releasing and rspec for tests.

To release a new version please make sure tests pass! Then,

```shell
% rake travis_release
```

This will tag the current state under the version number described in
metadata.json, and then bump the version there so we're ready for the next
iteration. Finally it will `git push --tags` so travis can pick it up and
release it to the forge!
