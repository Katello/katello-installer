class Kafo::Helpers # rubocop: disable Metrics/ClassLength
  class << self
    def success_message
      say "  <%= color('Success!', :good) %>"
    end

    def server_success_message(kafo)
      success_message
      say "  * <%= color('Katello', :info) %> is running at <%= color('#{kafo.param('foreman', 'foreman_url').value}', :info) %>"
    end

    def dev_server_success_message(kafo)
      success_message
      say "  * To run the <%= color('Katello', :info) %> dev server log in using SSH"
      say "  * Run `cd foreman && bundle exec foreman start`"
      say "  * The server is running at <%= color('https://#{`hostname -f`}', :info) %>"
      if kafo.param('katello_devel', 'webpack_dev_server').value
        say "  * On Firefox you need to accept the certificate at <%= color('https://#{`hostname -f`}:3808', :info) %>"
      end
    end

    def certs_generate_command_message
      say <<MSG
  * To install an additional Foreman proxy on separate machine continue by running:

      katello-generate-cert-archive --server-proxy-fqdn "<%= color('$FOREMAN_PROXY', :info) %>" --certs-tar "<%= color('/root/$FOREMAN_PROXY-certs.tar', :info) %>"
MSG
    end

    def proxy_success_message(kafo)
      success_message
      foreman_proxy_url = kafo.param('foreman_proxy', 'registered_proxy_url').value || "https://#{kafo.param('foreman_proxy', 'registered_name').value}:#{kafo.param('foreman_proxy', 'ssl_port').value}"
      say "  * <%= color('Foreman Proxy', :info) %> is running at <%= color('#{foreman_proxy_url}', :info) %>"
    end

    def new_install_message(kafo)
      say "      Initial credentials are <%= color('#{kafo.param('foreman', 'admin_username').value}', :info) %> / <%= color('#{kafo.param('foreman', 'admin_password').value}', :info) %>"
    end

    def dev_new_install_message(kafo)
      say "      Initial credentials are <%= color('admin', :info) %> / <%= color('#{kafo.param('katello_devel', 'admin_password').value}', :info) %>"
    end

    def certs_gen_instructions_message(kafo) # rubocop: disable Metrics/MethodLength
      if kafo.module('foreman_proxy_certs')
        fqdn        = kafo.param('foreman_proxy_certs', 'parent_fqdn').value || `hostname -f`.strip
        certs_tar   = kafo.param('foreman_proxy_certs', 'certs_tar').value
        server_fqdn = kafo.param('foreman_proxy_certs', 'foreman_proxy_fqdn').value
      elsif kafo.module('cert_generate_archive')
        fqdn = kafo.param('cert_generate_archive', 'parent_fqdn').value || `hostname -f`.strip
        certs_tar = kafo.param('cert_generate_archive', 'certs_tar').value
        server_fqdn = kafo.param('cert_generate_archive', 'server_fqdn').value
      end
      org = kafo.param('certs', 'org').value || "$ORG"
      success_message
      say <<MSG

  To finish the installation, follow these steps:

MSG
      if kafo.module('cert_generate_archive') && kafo.param('cert_generate_archive', 'foreman_application').value
        # foreman app
        foreman_app_instructions_message(certs_tar, server_fqdn)
      else
        # proxy certs
        initial_proxy_message(fqdn, org, server_fqdn, certs_tar)
        if fqdn == `hostname -f`.strip
          proxy_standalone_instructions_message(fqdn, server_fqdn, certs_tar)
        else
          proxy_split_instructions_message(fqdn, server_fqdn, certs_tar)
        end
      end
    end

    def initial_proxy_message(fqdn, org, server_fqdn, certs_tar)
      say <<MSG
  If you do not have the smartproxy registered to the Katello instance, then please do the following:

  1. yum -y localinstall http://#{fqdn}/pub/katello-ca-consumer-latest.noarch.rpm
  2. subscription-manager register --org "<%= color('#{org}', :info) %>"

  Once this is completed run the steps below to start the smartproxy installation:

  1. Ensure that the foreman-installer-katello package is installed on the system.
  2. Copy the following file <%= color("#{certs_tar}", :info) %> to the system <%= color("#{server_fqdn}", :info) %> at the following location <%= color("#{File.join('/root', File.basename(certs_tar))}", :info) %>
  scp <%= color("#{certs_tar}", :info) %> root@<%= color("#{server_fqdn}", :info) %>:<%= color("#{File.join('/root', File.basename(certs_tar))}", :info) %>
  3. Run the following commands on the Foreman proxy (possibly with the customized
     parameters, see <%= color("foreman-installer --scenario foreman-proxy-content --help", :info) %> and
     documentation for more info on setting up additional services):

MSG
    end

    def foreman_app_instructions_message(certs_tar, server_fqdn)
      candlepin_oauth_key = Kafo::Helpers.read_cache_data("candlepin_oauth_secret")
      candlepin_host = `hostname -f`.strip
      say <<MSG
  1. Ensure that the foreman-installer-katello package is installed on the system.
  2. Copy <%= color("#{certs_tar}", :info) %> to the system <%= color("#{server_fqdn}", :info) %>
  3. Run the following commands on the Foreman proxy (possibly with the customized
     parameters, see <%= color("foreman-installer --scenario katello --help", :info) %> and
     documentation for more info on setting up additional services):

  foreman-installer --scenario katello \\
                    --certs-generate false \\
                    --katello-manage-application true \\
                    --katello-manage-candlepin false \\
                    --katello-manage-qpid false \\
                    --katello-candlepin-hostname "<%= "#{candlepin_host}" %>" \\
                    --katello-qpid-hostname <%= color("$YOUR-QPID-HOST", :info) %> \\
                    --katello-manage-pulp false \\
                    --katello-pulp-hostname <%= color("$YOUR-PULP-HOST", :info) %> \\
                    --katello-package-names tfm-rubygem-katello \\
                    --katello-candlepin-oauth-secret "<%= "#{candlepin_oauth_key}" %>" \\
                    --no-enable-foreman-proxy \\
                    --no-enable-foreman-proxy-content \\
                    --no-enable-foreman-proxy-plugin-pulp
MSG
    end

    def proxy_split_instructions_message(fqdn, server_fqdn, certs_tar)
      say <<MSG
  foreman-installer --scenario foreman-proxy-content\\
                    --foreman-proxy-content-parent-fqdn           "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-register-in-foreman           "true"\\
                    --foreman-proxy-foreman-base-url              "https://<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{server_fqdn}" %>"\\
                    --foreman-proxy-oauth-consumer-key            "<%= color("$GET_FROM #{fqdn}", :info) %>"\\
                    --foreman-proxy-oauth-consumer-secret         "<%= color("$GET_FROM #{fqdn}", :info) %>"\\
                    --foreman-proxy-content-pulp-oauth-secret     "<%= color("$GET_FROM #{fqdn}", :info) %>"\\
                    --foreman-proxy-content-certs-tar             "<%= color('#{certs_tar}', :info) %>"
MSG
    end

    def proxy_standalone_instructions_message(fqdn, server_fqdn, certs_tar)
      foreman_oauth_key     = Kafo::Helpers.read_cache_data("oauth_consumer_key")
      foreman_oauth_secret  = Kafo::Helpers.read_cache_data("oauth_consumer_secret")

      say <<MSG
  foreman-installer --scenario foreman-proxy-content\\
                    --foreman-proxy-content-parent-fqdn           "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-register-in-foreman           "true"\\
                    --foreman-proxy-foreman-base-url              "https://<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{fqdn}" %>"\\
                    --foreman-proxy-trusted-hosts                 "<%= "#{server_fqdn}" %>"\\
                    --foreman-proxy-oauth-consumer-key            "<%= "#{foreman_oauth_key}" %>"\\
                    --foreman-proxy-oauth-consumer-secret         "<%= "#{foreman_oauth_secret}" %>"\\
                    --foreman-proxy-content-certs-tar             "<%= color("#{File.join('/root', File.basename(certs_tar))}", :info) %>"\\
                    --puppet-server-foreman-url                   "https://<%= "#{fqdn}" %>"
MSG
    end
  end
end
