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
        :docroot                 => '/srv/pulp',
        :ssl                     => true,
        :ssl_verify_client       => 'optional',
        :ssl_protocol            => ' all -SSLv2',
        :ssl_options             => '+StdEnvVars +ExportCertData',
        :ssl_verify_depth        => '3',
        :wsgi_process_group      => 'pulp',
        :wsgi_application_group  => 'pulp',
        :wsgi_daemon_process     => 'pulp user=apache group=apache processes=1 threads=8 display-name=%{GROUP}',
        :wsgi_pass_authorization => 'On',
        :wsgi_import_script      => '/srv/pulp/webservices.wsgi',
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
          :docroot                 => '/srv/pulp',
          :additional_includes     => '/etc/pulp/vhosts80/*.conf',
        })
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

# -- HTTPS Repositories ---------
Alias /pulp/repos /var/www/pub/yum/https/repos

# -- HTTPS Exports
Alias /pulp/exports /var/www/pub/yum/https/exports

<Directory /var/www/pub/yum/https>
    WSGIAccessScript /srv/pulp/repo_auth.wsgi
    SSLRequireSSL
    SSLVerifyClient require
    SSLVerifyDepth 2
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
    WSGIAccessScript /srv/pulp/repo_auth.wsgi
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
        :content => 'Alias /pulp/repos /var/www/pub/yum/http/repos
Alias /pulp/isos /var/www/pub/http/isos
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

Alias /pulp/docker /var/www/pub/docker/web

<Location /var/www/pub/docker/web>
    Options FollowSymLinks Indexes
</Location>
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

# for puppet < 3.3
WSGIScriptAlias /api/v1 /srv/pulp/puppet_forge_pre33_api.wsgi
# for puppet >= 3.3
WSGIScriptAlias /pulp_puppet/forge /srv/pulp/puppet_forge_post33_api.wsgi
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
')
      end
    end
  end

end
