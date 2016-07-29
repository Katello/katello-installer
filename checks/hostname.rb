#!/usr/bin/env ruby

BASE = %q(If needed, change the hostname permanently via 'hostname' command and editing
appropriate configuration file.
(e.g. on Red Hat systems /etc/sysconfig/network).

If 'hostname -f' still returns unexpected result, check /etc/hosts and put
hostname entry in the correct order, for example:

  1.2.3.4 full.hostname.com full

Fully qualified hostname must be the first entry on the line)

INVALID = %q(Output of 'hostname -f' does not seems to be valid FQDN

Make sure above command gives fully qualified domain name. At least one
dot must be present and underscores are not allowed. )

UPCASE = %q(The hostname contains a capital letter.

This is not supported. Please modify the hostname to be all lowercase. )

def error_exit(message, code)
  $stderr.puts message
  exit code
end

fqdn = `hostname -f`

# Every FQDN should have at least one dot
error_exit(INVALID + BASE, 2) unless fqdn.include?('.')
# Per https://bugzilla.redhat.com/show_bug.cgi?id=1205960 check for underscores
error_exit(INVALID + BASE, 2) if fqdn.include?('_')
# Capital Letters are not suported.
error_exit(UPCASE + BASE, 3) unless fqdn.downcase == fqdn
