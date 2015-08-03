[![Puppet Forge](http://img.shields.io/puppetforge/v/katello/service_wait.svg)](https://forge.puppetlabs.com/katello/service_wait)
[![Build Status](https://travis-ci.org/Katello/puppet-service_wait.svg?branch=master)](https://travis-ci.org/Katello/puppet-service_wait)
service-wait
============

Wrapper around service control command making sure that the service
is really running after start.

Motivation
----------

Imagine a simple process of setting up your web application, that
includes:

1. installing a database server
2. starting the server
3. preseeding the data

And now imagine, that `service $DATABASE_SERVER start` finishes but
the service is still unavailable due to setup procedures. This happens
with almost every network service.

Also, some services do not start or stop properly and return non-zero values
for some commands.

This simple wrapper works with any service and just pass over the request
to service controller, but for few problematic ones it waits until service is
fully started or stopped.

CLI
---

Service-wait let's you specify what it means the service
is running using a plugin architecture (with simple bash scripts).

Then, instead of `service $DATABSE_SERVER start` you use `service-wait
$DATABASE_SERVER start`.

Puppet
------

Now imagine that you want to automate the described setup process
using Puppet. This library includes a Puppet provider for service
resources that wraps the `service-wait` script so that you can reuse
the existing puppet modules that make sure that the required services
are really running.

Plugin anatomy
--------------

The plugins can be found in `plugins` directory (or specifying using
`$PLUGINS_DIR` environment variable.

Here is an annotated example:

```bash
# REQUIRED: test so determine if this plugin is usable with given service
confine [ $SERVICE = 'tomcat6' -o $SERVICE = 'tomcat7' ]

# OPTIONAL: sometimes the service command fails even if the service
#           starts (some bug probably). This let's you to ignore the
#           exit code of the original service command and use your
#           criteria on determining whether the service is running or
#           not.
ignore-retval

# this function gets loaded when the serivce is started/restarted and
# it should finish when the service is really running (performing some
# periodic checks on the status).
service-wait () {
    # the status can be determined by asking on some url
    wait-for-url http://localhost:3000
    # or the service listening on a port
    wait-for-port 3000
    # or some command to be successful
    wait-for-command serviceready

    # the status can be checked using $RETVAL variable
    if [ $RETVAL -eq 0 ]; then
       echo "success"
    fi
}
```

Supported OSes
--------------

Currently, service-wait is tested with RHEL/CentOS/Fedora distributions.

License
-------

Copyright 2013 Red Hat, Inc.
GPLv2
