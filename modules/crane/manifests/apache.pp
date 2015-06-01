# Sets up Apache for Crane
class crane::apache {

  include ::apache
  include ::apache::mod::headers
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http

  apache::vhost { 'crane':
    servername          => $crane::fqdn,
    docroot             => '/usr/share/crane/',
    wsgi_script_aliases =>
                          {
                            '/' => '/usr/share/crane/crane.wsgi',
                          },
    port                => $crane::port,
    priority            => '03',
    ssl                 => true,
    ssl_cert            => $crane::cert,
    ssl_key             => $crane::key,
    ssl_ca              => $crane::ca_cert,
    ssl_chain           => $crane::ca_cert,
    ssl_verify_client   => 'optional',
    ssl_options         => '+StdEnvVars +ExportCertData +FakeBasicAuth',
    ssl_verify_depth    => '3',
    ssl_proxyengine     => true,
  }
}
