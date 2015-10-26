# configure apache
class pulp::apache {
  include ::apache
  include ::apache::mod::wsgi
  include ::apache::mod::ssl

  if $pulp::manage_httpd {
    if $pulp::enable_http or $pulp::enable_puppet {
      apache::vhost { 'pulp-http':
        priority            => '05',
        docroot             => '/srv/pulp',
        port                => 80,
        servername          => $::fqdn,
        serveraliases       => [$::hostname],
        additional_includes => '/etc/pulp/vhosts80/*.conf',
      }
    }

    apache::vhost { 'pulp-https':
      priority                   => '05',
      docroot                    => '/srv/pulp',
      port                       => 443,
      servername                 => $::fqdn,
      serveraliases              => [$::hostname],
      ssl                        => true,
      ssl_cert                   => $pulp::https_cert,
      ssl_key                    => $pulp::https_key,
      ssl_ca                     => $pulp::ca_cert,
      ssl_verify_client          => 'optional',
      ssl_protocol               => ' all -SSLv2',
      ssl_options                => '+StdEnvVars +ExportCertData',
      ssl_verify_depth           => '3',
      wsgi_process_group         => 'pulp',
      wsgi_application_group     => 'pulp',
      wsgi_daemon_process        => 'pulp user=apache group=apache processes=1 threads=8 display-name=%{GROUP}',
      wsgi_pass_authorization    => 'On',
      wsgi_import_script         => '/srv/pulp/webservices.wsgi',
      wsgi_import_script_options => {
        'process-group'     => 'pulp',
        'application-group' => 'pulp',
      },
      wsgi_script_aliases        => {
        '/pulp/api' => '/srv/pulp/webservices.wsgi',
      },
      directories                => [
        {
          'path'     => 'webservices.wsgi',
          'provider' => 'files',
        },
        {
          'path'     => '/srv/pulp',
          'provider' => 'directory',
        },
        {
          'path'     => '/pulp/static',
          'provider' => 'location',
        },
      ],
      aliases                    => [{
          alias           => '/pulp/static',
          path            => '/var/lib/pulp/static',
          options         => ['Indexes'],
          custom_fragment => 'SSLRequireSSL'
        }
      ],
      options                    => ['SymLinksIfOwnerMatch'],
      add_default_charset        => 'UTF-8',
      custom_fragment            => '# allow older yum clients to connect, see bz 647828
	  SSLInsecureRenegotiation on',
    }
  }

  if $pulp::manage_httpd or $pulp::manage_plugins_httpd {
    file { '/etc/pulp/vhosts80/':
      ensure => directory,
      owner  => 'apache',
      group  => 'apache',
      mode   => '0755',
      purge  => true,
    }

    if $pulp::enable_rpm {
      pulp::apache_plugin { 'rpm': }
    }

    if $pulp::enable_docker {
      pulp::apache_plugin { 'docker': vhosts80 => false }
    }

    if $pulp::enable_puppet {
      pulp::apache_plugin { 'puppet': }
    }

    if $pulp::enable_python {
      pulp::apache_plugin { 'python': }
    }

    if $pulp::enable_parent_node {
      pulp::apache_plugin { 'nodes': vhosts80 => false }
    }
  }
}
