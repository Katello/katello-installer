#!/usr/bin/env ruby

# checking to see if http/https proxy envs are set before running the installer

http_proxy = ENV['http_proxy']
https_proxy = ENV['https_proxy']

PROXYSET = "Please unset the http_proxy and/or https_proxy environment variables before running the installer"

def error_exit(message, code)
  $stderr.puts message
  exit code
end

error_exit(PROXYSET, 1) if http_proxy != nil || https_proxy != nil
