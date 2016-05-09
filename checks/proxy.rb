#!/usr/bin/env ruby

# checking to see if http/https proxy envs are set before running the installer

http_proxy = ENV['http_proxy']
https_proxy = ENV['https_proxy']

PROXYSET = "Currently there is a environmental proxy variable set. Katello does a check on services when running the installer to make sure services are running correctly. Please unset this and then run katello-installer again. Once the installer finishes you can set the proxy variables back."

def error_exit(message, code)
  $stderr.puts message
  exit code
end

error_exit(PROXYSET, 1) if http_proxy != nil || https_proxy != nil
