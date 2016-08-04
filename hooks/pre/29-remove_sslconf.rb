#!/usr/bin/env ruby

# check if file exists and if so remove it

File.delete("/etc/httpd/conf.d/ssl.conf") if File.file?("/etc/httpd/conf.d/ssl.conf")
