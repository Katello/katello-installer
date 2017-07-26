#!/usr/bin/env ruby
# Check to verify forward / reverse dns matches hostname

def error_exit(message, code)
  $stderr.puts message
  exit code
end

@hostname = `hostname -f`.chomp
@ip = `getent ahosts #{@hostname} | awk '/STREAM/ { print $1 }'`.chomp
@reverse = `getent hosts #{@ip} | awk '{ print $2 }'`.chomp

FORWARD = "Unable to resolve forward DNS for #{@hostname}"

POINTS = "Forward DNS points to #{@ip} which is not configured on this server"

REVERSE = "Reverse DNS #{@reverse} does not match hostname #{@hostname}"

if @ip.empty?
  error_exit(FORWARD, 2)
end

`ip -o a | awk '/ #{@ip}\\// { print $4 }' | cut -d/ -f1`.chomp
unless $?.success?
  error_exit(POINTS, 2)
end

unless @hostname == @reverse
  error_exit(REVERSE, 2)
end
