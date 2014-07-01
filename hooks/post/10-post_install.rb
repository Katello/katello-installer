# helpers
def module_enabled?(name)
  mod = @kafo.module(name)
  return false if mod.nil?
  mod.enabled?
end

def proxy_available?
  module_enabled?('capsule') &&
   (@kafo.param('capsule', 'puppet').value ||
    @kafo.param('capsule', 'puppetca').value ||
    @kafo.param('capsule', 'dhcp').value ||
    @kafo.param('capsule', 'dns').value ||
    @kafo.param('capsule', 'tftp').value)
end

def read_cache_data(param)
  YAML.load_file("/var/lib/puppet/foreman_cache_data/#{param}")
end

if [0,2].include? @kafo.exit_code

  fqdn = Facter.value(:fqdn)

  say "  <%= color('Success!', :good) %>"

  # Fortello UI?
  if module_enabled?('katello')
    say "  * <%= color('Katello', :info) %> is running at <%= color('#{@kafo.param('foreman','foreman_url').value}', :info) %>"
    say "      Initial credentials are <%= color('#{@kafo.param('foreman', 'admin_username').value}', :info) %> / <%= color('#{@kafo.param('foreman', 'admin_password').value}', :info) %>" if @kafo.param('foreman','authentication').value == true
  end

  # Capsule?
  if proxy_available?
    say "  * <%= color('Capsule', :info) %> is running at <%= color('https://#{fqdn}:#{@kafo.param('capsule', 'foreman_proxy_port').value}', :info) %>"
  end

  if module_enabled?('katello')
    say <<MSG
  * To install additional capsule on separate machine continue by running:"

      capsule-certs-generate --capsule-fqdn "<%= color('$CAPSULE', :info) %>" --certs-tar "<%= color('~/$CAPSULE-certs.tar', :info) %>"

MSG
  end

  if module_enabled?('capsule_certs')
    if certs_tar = @kafo.param('capsule_certs', 'certs_tar').value
      capsule_fqdn          = @kafo.param('capsule_certs', 'capsule_fqdn').value
      foreman_oauth_key     = read_cache_data("oauth_consumer_key")
      foreman_oauth_secret  = read_cache_data("oauth_consumer_secret")
      katello_oauth_secret  = read_cache_data("katello_oauth_secret")
      org                   = "ACME_Corporation"
      say <<MSG

  To finish the installation, follow these steps:

  1. Ensure that the capsule-installer is available on the system.
     The capsule-installer comes from the katello-installer package and
     should be acquired through the means that are appropriate to your deployment.
  2. Copy <%= color("#{certs_tar}", :info) %> to the system <%= color("#{capsule_fqdn}", :info) %>
  3. Run the following commands on the capsule (possibly with the customized
     parameters, see <%= color("capsule-installer --help", :info) %> and
     documentation for more info on setting up additional services):

  rpm -Uvh http://#{fqdn}/pub/katello-ca-consumer-latest.noarch.rpm
  subscription-manager register --org "<%= color('#{org}', :info) %>"
  capsule-installer --parent-fqdn          "<%= "#{fqdn}" %>"\\
                    --register-in-foreman  "true"\\
                    --foreman-oauth-key    "<%= "#{foreman_oauth_key}" %>"\\
                    --foreman-oauth-secret "<%= "#{foreman_oauth_secret}" %>"\\
                    --pulp-oauth-secret    "<%= "#{katello_oauth_secret}" %>"\\
                    --certs-tar            "<%= color('#{certs_tar}', :info) %>"\\
                    --puppet               "<%= color('true', :info) %>"\\
                    --puppetca             "<%= color('true', :info) %>"\\
                    --pulp                 "<%= color('true', :info) %>"
MSG
    end
  end

  exit_code = 0
else
  say "  <%= color('Something went wrong!', :bad) %> Check the log for ERROR-level output"
  exit_code = @kafo.exit_code
end

# This is always useful, success or fail
log = @kafo.config.app[:log_dir] + '/' + @kafo.config.app[:log_name]
say "  The full log is at <%= color('#{log}', :info) %>"
