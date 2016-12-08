# Some packages like mod_ssl and pulp place configuration files in
# /etc/httpd/conf.d that contain duplicates declarations of directives
# that the puppetlabs-apache module configured elsewhere.
#
# * pulp places a pulp.conf that contains a duplicate WSGI 'pulp'
#   daemon that 05-pulps-https.conf contains.
#
# * mod_ssl places a 'Listen 443' directive in ssl.conf that ports.conf already
#   has.

%w(ssl.conf pulp.conf).each do |file|
  File.delete(File.join("/etc/httpd/conf.d/", file)) if File.file?(File.join("/etc/httpd/conf.d/", file))
end
