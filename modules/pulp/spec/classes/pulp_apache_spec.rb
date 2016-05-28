require 'spec_helper'

describe 'pulp::apache' do
  let :pre_condition do
    "class {'pulp':}"
  end

  let :default_facts do
    {
      :concat_basedir             => '/tmp',
      :interfaces                 => '',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6.4',
      :osfamily                   => 'RedHat',
      :fqdn                       => 'pulp.compony.net',
      :hostname                   => 'pulp',
    }
  end

  context 'with no parameters' do
    let :facts do
      default_facts
    end

    it 'should include apache with modules' do
      is_expected.to contain_class('apache')
      is_expected.to contain_class('apache::mod::wsgi')
      is_expected.to contain_class('apache::mod::ssl')
    end

    it { is_expected.to contain_file('/etc/pulp/vhosts80/')}

    it 'should configure apache server with ssl' do
      is_expected.to contain_apache__vhost('pulp-https').with({
        :priority                => '05',
        :port                    => 443,
        :servername              => facts[:fqdn],
        :serveraliases           => [facts[:hostname]],
        :docroot                 => '/usr/share/pulp/wsgi',
        :ssl                     => true,
        :ssl_verify_client       => 'optional',
        :ssl_protocol            => ' all -SSLv2',
        :ssl_options             => '+StdEnvVars +ExportCertData',
        :ssl_verify_depth        => '3',
        :wsgi_process_group      => 'pulp',
        :wsgi_application_group  => 'pulp',
        :wsgi_daemon_process     => 'pulp user=apache group=apache processes=3 display-name=%{GROUP}',
        :wsgi_pass_authorization => 'On',
        :wsgi_import_script      => '/usr/share/pulp/wsgi/webservices.wsgi',
      })
    end
  end

  context 'with parameters' do
    let :facts do
      default_facts
    end

    describe 'with enable_http false' do
      let :pre_condition do
        "class {'pulp': enable_http => false}"
      end

      it { should_not contain_apache__vhost('pulp-http') }
    end

    describe 'with manage_httpd false & manage_plugins_httpd true' do
      let :pre_condition do
        "class {'pulp': manage_httpd => false, manage_plugins_httpd => true, enable_rpm => true}"
      end

       it { should_not contain_apache__vhost('pulp-http') }
       it { is_expected.to contain_file('/etc/httpd/conf.d/pulp_rpm.conf') }
    end

    describe 'with enable_http true' do
      let :pre_condition do
        "class {'pulp': enable_http => true}"
      end

      it 'should configure http' do
        is_expected.to contain_apache__vhost('pulp-http').with({
          :priority                => '05',
          :port                    => 80,
          :servername              => facts[:fqdn],
          :serveraliases           => [facts[:hostname]],
          :docroot                 => '/usr/share/pulp/wsgi',
          :additional_includes     => '/etc/pulp/vhosts80/*.conf',
        })
      end
    end

    describe 'with manage_httpd true or manage_plugins_httpd true' do
      let :pre_condition do
        "class {'pulp': manage_httpd => true}"
      end

      it 'should configure pulp_content' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_content.conf').with(
        :content => 'WSGISocketPrefix run/wsgi
WSGIProcessGroup pulp-content
WSGIApplicationGroup pulp-content
WSGIScriptAlias /pulp/content /usr/share/pulp/wsgi/content.wsgi
WSGIDaemonProcess pulp-content user=apache group=apache processes=3 display-name=%{GROUP}
WSGIImportScript /usr/share/pulp/wsgi/content.wsgi process-group=pulp-content application-group=pulp-content

<Files content.wsgi>
    WSGIPassAuthorization On
    WSGIProcessGroup pulp-content
    WSGIApplicationGroup pulp-content
    SSLRenegBufferSize  1048576
    SSLVerifyDepth 9
    SSLOptions +StdEnvVars +ExportCertData
    SSLVerifyClient require
</Files>

<Location /pulp/content/>
    XSendFile on
    XSendFilePath /var/lib/pulp/content
    XSendFilePath /var/lib/pulp/published
</Location>
')
      end
    end

    describe 'with enable_rpm' do
      let :pre_condition do
        "class {'pulp': enable_rpm => true}"
      end

      it 'should configure apache for serving rpm' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_rpm.conf').with(
        :content => '#
# Apache configuration file for pulp web services and repositories
#

AddType application/x-pkcs7-crl .crl
AddType application/x-x509-ca-cert .crt

# -- Yum Repositories ---------
#
# This Location block replaces an `Alias` directive. In order to maintain
# backwards compatibility with existing Yum repository configurations, this
# block rewrites all requests to `/pulp/repos/` to the location of the WSGI
# application, content.wsgi, provided by the Pulp platform. The content.wsgi
# application adds support for downloading content on-demand.
<Location /pulp/repos/>
  RewriteEngine On
  RewriteCond %{HTTPS} on
  RewriteRule (.+/pulp/repos/)(.*) /pulp/content/var/www/pub/yum/https/repos/$2 [DPI]
  RewriteCond %{HTTPS} off
  RewriteRule (.+/pulp/repos/)(.*) /pulp/content/var/www/pub/yum/http/repos/$2 [DPI]
</Location>

# -- HTTPS Exports
Alias /pulp/exports /var/www/pub/yum/https/exports

<Directory /var/www/pub/yum/https>
    WSGIAccessScript /usr/share/pulp/wsgi/repo_auth.wsgi
    SSLRequireSSL
    SSLVerifyClient require
    SSLVerifyDepth 9
    SSLOptions +StdEnvVars +ExportCertData +FakeBasicAuth
    Options FollowSymLinks Indexes
</Directory>

# -- HTTP Repositories ---------
<Directory /var/www/pub/yum/http>
    Options FollowSymLinks Indexes
</Directory>

# -- HTTPS ISOS
Alias /pulp/isos /var/www/pub/https/isos

<Directory /var/www/pub/https/isos>
    WSGIAccessScript /usr/share/pulp/wsgi/repo_auth.wsgi
    SSLRequireSSL
    SSLVerifyClient require
    SSLVerifyDepth 2
    SSLOptions +StdEnvVars +ExportCertData +FakeBasicAuth
    Options FollowSymLinks Indexes
</Directory>

# --- HTTP ISOS
<Directory /var/www/pub/http/isos >
    Options FollowSymLinks Indexes
</Directory>


# -- GPG Keys -------------------
Alias /pulp/gpg /var/www/pub/gpg

<Directory /var/www/pub/gpg/>
    Options FollowSymLinks Indexes
</Directory>
')

        is_expected.to contain_file('/etc/pulp/vhosts80/rpm.conf').with(
        :content => 'Alias /pulp/isos /var/www/pub/http/isos
Alias /pulp/exports /var/www/pub/yum/http/exports
')
      end
    end

    describe 'with enable_docker' do
      let :pre_condition do
        "class {'pulp': enable_docker => true}"
      end

      it 'should configure apache for serving docker' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_docker.conf').with(
        :content => '#
# Apache configuration file for Pulp\'s Docker support
#

# -- HTTPS Repositories ---------

# This prevents mod_mime_magic from adding content-type and content-encoding headers, which will confuse the Docker
# client.
MimeMagicFile NEVER_EVER_USE

# Docker v2
Alias /pulp/docker/v2 /var/www/pub/docker/v2/web
<Directory /var/www/pub/docker/v2/web>
    Header set Docker-Distribution-API-Version "registry/2.0"
    SSLRequireSSL
    Options FollowSymlinks Indexes
</Directory>

# Docker v1
Alias /pulp/docker/v1 /var/www/pub/docker/v1/web
<Directory /var/www/pub/docker/v1/web>
    SSLRequireSSL
    Options FollowSymLinks Indexes
</Directory>
')
      end
    end

    describe 'with enable_puppet' do
      let :pre_condition do
        "class {'pulp': enable_puppet => true}"
      end

      it 'should configure apache for serving puppet' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_puppet.conf').with(
        :content => '#
# Apache configuration file for Pulp\'s Puppet support
#

# -- HTTPS Repositories ---------

Alias /pulp/puppet /var/www/pub/puppet/https/repos

<Directory /var/www/pub/puppet/https/repos>
    Options FollowSymLinks Indexes
</Directory>

# -- HTTP Repositories ----------

<Directory /var/www/pub/puppet/http/repos>
    Options FollowSymLinks Indexes
</Directory>

# -- Files Repositories ----------

Alias /pulp/puppet_files /var/www/pub/puppet/files

<Directory /var/www/pub/puppet/files>
    SSLRequireSSL
    SSLVerifyClient optional_no_ca
    SSLVerifyDepth 2
    SSLOptions +StdEnvVars +ExportCertData +FakeBasicAuth
    Options FollowSymLinks Indexes
</Directory>

# The puppet module tool does url joins improperly. When we send it a path to a
# file like "/pulp/puppet/demo/system/releases/p/puppetlabs/puppetlabs-stdlib-3.1.0.tar.gz",
# it treats that like a relative path instead of absolute. The following redirect
# compensates for this. The only path that should be available under
# /pulp_puppet/forge/ is /pulp_puppet/forge/<consumer|repository>/consumer_id|repo_id>/api/v1/releases.json
# and so the following redirect will match any path that isn\'t the above.
RedirectMatch ^\/?pulp_puppet\/forge\/[^\/]+\/[^\/]+\/(?!api\/v1\/releases\.json)(.*)$ /$1

WSGIDaemonProcess pulp_forge user=apache group=apache processes=3 display-name=%{GROUP}
WSGIProcessGroup pulp_forge
WSGIApplicationGroup pulp_forge
WSGIScriptAlias /api/v1 /usr/share/pulp/wsgi/puppet_forge.wsgi process-group=pulp_forge application-group=pulp_forge
WSGIScriptAlias /pulp_puppet/forge /usr/share/pulp/wsgi/puppet_forge.wsgi process-group=pulp_forge application-group=pulp_forge
WSGIScriptAlias /v3 /usr/share/pulp/wsgi/puppet_forge.wsgi process-group=pulp_forge application-group=pulp_forge
WSGIPassAuthorization On
')

        is_expected.to contain_file('/etc/pulp/vhosts80/puppet.conf').with(
        :content => 'Alias /pulp/puppet /var/www/pub/puppet/http/repos
')
      end
    end

    describe 'with enable_python' do
      let :pre_condition do
        "class {'pulp': enable_python => true}"
      end

      it 'should configure apache for serving python' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_python.conf').with(
        :content => '#
# Apache configuration file for Pulp\'s Python support
#

# -- HTTPS Repositories ---------

Alias /pulp/python /var/www/pub/python/

<Directory /var/www/pub/python>
    Options FollowSymLinks Indexes
</Directory>
')
      end
    end


    describe 'with enable_ostree' do
      let :pre_condition do
        "class {'pulp': enable_ostree => true}"
      end

      it 'should configure apache for serving ostree' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_ostree.conf').with(
        :content => '#
# Apache configuration file for Pulp\'s OSTree support
#

# -- HTTPS Repositories ---------

Alias /pulp/ostree /var/www/pub/ostree/

<Directory /var/www/pub/ostree>
    WSGIAccessScript /usr/share/pulp/wsgi/repo_auth.wsgi
    SSLRequireSSL
    SSLVerifyClient require
    SSLVerifyDepth 2
    SSLOptions +StdEnvVars +ExportCertData +FakeBasicAuth
    Options FollowSymLinks Indexes
</Directory>
')
      end
    end

    describe 'with enable_parent_node' do
      let :pre_condition do
        "class {'pulp': enable_parent_node => true}"
      end

      it 'should configure apache for defining a parent node' do
        is_expected.to contain_file('/etc/httpd/conf.d/pulp_nodes.conf').with(
        :content => '#
# Apache configuration file for pulp web services and repositories
#

# -- HTTP Repositories ---------

Alias /pulp/nodes/http/repos /var/www/pulp/nodes/http/repos

<Directory /var/www/pulp/nodes/http/repos >
  Options FollowSymLinks Indexes
</Directory>

# -- HTTPS Repositories ---------

Alias /pulp/nodes/https/repos /var/www/pulp/nodes/https/repos

<Directory /var/www/pulp/nodes/https/repos >
  Options FollowSymLinks Indexes
  SSLRequireSSL
  SSLVerifyClient require
  SSLVerifyDepth  5
  SSLOptions +FakeBasicAuth
  SSLRequire %{SSL_CLIENT_S_DN_O} eq "PULP" and %{SSL_CLIENT_S_DN_OU} eq "NODES"
</Directory>

Alias /pulp/nodes/content /var/www/pulp/nodes/content

<Directory /var/www/pulp/nodes/content >
  Options FollowSymLinks Indexes
  SSLRequireSSL
  SSLVerifyClient require
  SSLVerifyDepth  5
  SSLOptions +FakeBasicAuth
  SSLRequire %{SSL_CLIENT_S_DN_O} eq "PULP" and %{SSL_CLIENT_S_DN_OU} eq "NODES"
</Directory>
')
      end
    end
  end

end
