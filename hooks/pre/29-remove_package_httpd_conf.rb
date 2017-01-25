# Pulp places a configuration file in /etc/httpd/conf.d that
# contain duplicates declarations of directives that the puppetlabs-apache
# module configured elsewhere. This is only relevant on smart proxies.
# The main katello install overwrites the pulp.conf.
#
# * pulp places a pulp.conf that contains a duplicate WSGI 'pulp'
#   daemon that 05-pulps-https.conf contains.
#
if !Kafo::Helpers.module_enabled?(@kafo, 'katello') && !app_value(:noop)
  %w(pulp.conf).each do |file|
    File.delete(File.join("/etc/httpd/conf.d/", file)) if File.file?(File.join("/etc/httpd/conf.d/", file))
  end
end
