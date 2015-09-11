#Adds http reverse-proxy to parent conf
class capsule::reverse_proxy (

  $path = '/',
  $url  = "https://${capsule::parent_fqdn}/",
  $port = $capsule::params::reverse_proxy_port

  ) {

  include ::apache

  Class['certs::foreman_proxy'] ~>
  apache::vhost { 'katello-reverse-proxy':
    servername        => $capsule::capsule_fqdn,
    port              => $port,
    docroot           => '/var/www/',
    priority          => '28',
    ssl_options       => ['+StdEnvVars',
                          '+ExportCertData',
                          '+FakeBasicAuth'],
    ssl               => true,
    ssl_proxyengine   => true,
    ssl_cert          => $certs::apache::apache_cert,
    ssl_key           => $certs::apache::apache_key,
    ssl_ca            => $certs::ca_cert,
    ssl_verify_client => 'optional',
    ssl_verify_depth  => 10,
    request_headers   => ['set X_RHSM_SSL_CLIENT_CERT "%{SSL_CLIENT_CERT}s"'],
    proxy_pass        => [{
      'path'         => $path,
      'url'          => $url,
      'reverse_urls' => [$path, $url]
    }],
    error_documents   => [{
        'error_code' => '503',
        'document'   => '\'{"displayMessage": "Internal error, contact administrator", "errors": ["Internal error, contact administrator"], "status": "500" }\''
      },
      {
        'error_code' => '503',
        'document'   => '\'{"displayMessage": "Service unavailable or restarting, try later", "errors": ["Service unavailable or restarting, try later"], "status": "503" }\''
      },
    ],
    custom_fragment   => "
      SSLProxyCACertificateFile ${::certs::ca_cert}
      SSLProxyMachineCertificateFile ${certs::foreman_proxy::foreman_proxy_ssl_client_bundle}
    ",
  }
}
