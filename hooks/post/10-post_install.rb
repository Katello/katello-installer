def proxy_available?
  Kafo::Helpers.module_enabled?(@kafo, 'capsule') &&
   (@kafo.param('capsule', 'puppet').value ||
    @kafo.param('foreman_proxy', 'puppetca').value ||
    @kafo.param('foreman_proxy', 'dhcp').value ||
    @kafo.param('foreman_proxy', 'dns').value ||
    @kafo.param('foreman_proxy', 'tftp').value)
end

def success_file
  File.join(File.dirname(Kafo::KafoConfigure.config_file), '.installed')
end

def new_install?
  !File.exist?(success_file)
end

installer_name = kafo.config.app[:installer_name] || kafo.invocation_path

if [0,2].include?(@kafo.exit_code)
  if !app_value(:upgrade)
    fqdn = if @kafo.param('capsule_certs','parent_fqdn')
             @kafo.param('capsule_certs', 'parent_fqdn').value
           else
             Facter.value(:fqdn)
           end

    say "  <%= color('Success!', :good) %>"

    # Fortello UI?
    if Kafo::Helpers.module_enabled?(@kafo, 'katello')
      say "  * <%= color('Katello', :info) %> is running at <%= color('#{@kafo.param('foreman','foreman_url').value}', :info) %>"
      say "      Initial credentials are <%= color('#{@kafo.param('foreman', 'admin_username').value}', :info) %> / <%= color('#{@kafo.param('foreman', 'admin_password').value}', :info) %>" if @kafo.param('foreman','authentication').value == true && new_install?
    end

    if Kafo::Helpers.module_enabled?(@kafo, 'katello')
      say <<MSG
  * To install additional capsule on separate machine continue by running:

      capsule-certs-generate --capsule-fqdn "<%= color('$CAPSULE', :info) %>" --certs-tar "<%= color('~/$CAPSULE-certs.tar', :info) %>"

MSG
    end

    if Kafo::Helpers.module_enabled?(@kafo, 'capsule_certs')
      if certs_tar = @kafo.param('capsule_certs', 'certs_tar').value
        capsule_fqdn          = @kafo.param('capsule_certs', 'capsule_fqdn').value
        foreman_oauth_key     = Kafo::Helpers.read_cache_data("oauth_consumer_key")
        foreman_oauth_secret  = Kafo::Helpers.read_cache_data("oauth_consumer_secret")
        katello_oauth_secret  = Kafo::Helpers.read_cache_data("katello_oauth_secret")
        org                   = @kafo.param('certs', 'org').value
        say <<MSG

  To finish the installation, follow these steps:

  If you do not have the smartproxy registered to the Katello instance, then please do the following:

  1. yum -y localinstall http://#{fqdn}/pub/katello-ca-consumer-latest.noarch.rpm
  2. subscription-manager register --org "<%= color('#{org}', :info) %>"

  Once this is completed run the steps below to start the smartproxy installation:

  1. Ensure that the foreman-installer-katello package is installed on the system.
  2. Copy <%= color("#{certs_tar}", :info) %> to the system <%= color("#{capsule_fqdn}", :info) %>
  3. Run the following commands on the capsule (possibly with the customized
     parameters, see <%= color("#{installer_name} --scenario capsule --help", :info) %> and
     documentation for more info on setting up additional services):

  #{installer_name} --scenario capsule\\
                    --capsule-parent-fqdn                         "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-register-in-foreman           "true"\\
                    --foreman-proxy-foreman-base-url              "https://<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{capsule_fqdn}" %>"\\
                    --foreman-proxy-oauth-consumer-key            "<%= "#{foreman_oauth_key}" %>"\\
                    --foreman-proxy-oauth-consumer-secret         "<%= "#{foreman_oauth_secret}" %>"\\
                    --capsule-pulp-oauth-secret                   "<%= "#{katello_oauth_secret}" %>"\\
                    --capsule-certs-tar                           "<%= color('#{certs_tar}', :info) %>"
MSG
      end
    end
  end

  File.open(success_file, 'w') {} unless app_value(:noop) # Used to indicate that we had a successful install
  exit_code = 0
else
  say "  <%= color('Something went wrong!', :bad) %> Check the log for ERROR-level output"
  exit_code = @kafo.exit_code
end

# This is always useful, success or fail
log = @kafo.config.app[:log_dir] + '/' + @kafo.config.app[:log_name]
say "  The full log is at <%= color('#{log}', :info) %>"
