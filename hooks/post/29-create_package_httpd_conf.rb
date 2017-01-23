# Some packages like pulp place configuration files in /etc/httpd/conf.d that
# contain duplicates declarations of directives that the puppetlabs-apache
# module configured elsewhere.
#
# * pulp places a pulp.conf that contains a duplicate WSGI 'pulp'
#   daemon that 05-pulps-https.conf contains.
#
# This hook creates placeholders files so the package does not put them in
# place anymore.
#
if !app_value(:noop)
  %w(pulp.conf).each do |file|
    if !File.file?(File.join("/etc/httpd/conf.d/", file))
      File.open(File.join('/etc/httpd/conf.d', file), 'w') do |f|
        f.write("# This file is managed by the foreman-installer, do not alter.")
      end
    else
      logger.info "#{file} is already present, skipping"
    end
  end
end
