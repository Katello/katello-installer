# configure apache
class pulp::apache {
  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::wsgi
  include ::apache::mod::ssl
  include ::apache::mod::xsendfile

  $apache_version = $::apache::apache_version

  if $pulp::manage_httpd {
    if $pulp::enable_http or $pulp::enable_puppet {
      apache::vhost { 'pulp-http':
        priority            => '05',
        docroot             => '/usr/share/pulp/wsgi',
        port                => 80,
        servername          => $::fqdn,
        serveraliases       => [$::hostname],
        additional_includes => '/etc/pulp/vhosts80/*.conf',
      }
    }

    apache::vhost { 'pulp-https':
      priority                   => '05',
      docroot                    => '/usr/share/pulp/wsgi',
      port                       => 443,
      servername                 => $::fqdn,
      serveraliases              => [$::hostname],
      ssl                        => true,
      ssl_cert                   => $pulp::https_cert,
      ssl_key                    => $pulp::https_key,
      ssl_chain                  => $pulp::https_chain,
      ssl_ca                     => $pulp::ca_cert,
      ssl_verify_client          => 'optional',
      ssl_protocol               => ' all -SSLv2',
      ssl_options                => '+StdEnvVars +ExportCertData',
      ssl_verify_depth           => '3',
      wsgi_process_group         => 'pulp',
      wsgi_application_group     => 'pulp',
      wsgi_daemon_process        => 'pulp user=apache group=apache processes=3 display-name=%{GROUP}',
      wsgi_pass_authorization    => 'On',
      wsgi_import_script         => '/usr/share/pulp/wsgi/webservices.wsgi',
      wsgi_import_script_options => {
        'process-group'     => 'pulp',
        'application-group' => 'pulp',
      },
      wsgi_script_aliases        => merge(
        {'/pulp/api'=>'/usr/share/pulp/wsgi/webservices.wsgi'},
        $pulp::additional_wsgi_scripts),
      directories                => [
        {
          'path'     => 'webservices.wsgi',
          'provider' => 'files',
        },
        {
          'path'     => '/usr/share/pulp/wsgi',
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
      custom_fragment            => template('pulp/etc/httpd/conf.d/_ssl_vhost.conf.erb'),
    }
  } else {
    file {'/etc/httpd/conf.d/pulp.conf':
      ensure  => file,
      content => template('pulp/pulp.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $pulp::manage_httpd or $pulp::manage_plugins_httpd {
    pulp::apache_plugin {'content' : vhosts80 => false}

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
      include ::apache::mod::headers
      pulp::apache_plugin { 'docker': vhosts80 => false }
    }

    if $pulp::enable_puppet {
      pulp::apache_plugin { 'puppet': }
    }

    if $pulp::enable_python {
      pulp::apache_plugin { 'python': }
    }

    if $pulp::enable_ostree {
      pulp::apache_plugin { 'ostree': vhosts80 => false }
    }

    if $pulp::enable_parent_node {
      pulp::apache_plugin { 'nodes': vhosts80 => false }
    }
  }

  file {'/etc/httpd/conf.d/pulp_streamer.conf':
    ensure  => file,
    content => template('pulp/etc/httpd/conf.d/pulp_streamer.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
