# post hook to create an ssl.conf file to work-around this issue http://projects.theforeman.org/issues/16972 until mod_ssl packging is fixed.

if File.file?('/etc/httpd/conf.d/ssl.conf')
  logger.info 'ssl.conf is already present, skipping'
else
  File.open('/etc/httpd/conf.d/ssl.conf', 'w') { |file| file.write("# This file is managed by the foreman-installer, do not alter.") }
end
