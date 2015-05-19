# Setups Apache for Katello development
class katello_devel::apache {

  include ::apache
  include ::apache::mod::headers
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http

  $apache_version = $::apache::apache_version

  apache::vhost { 'katello-ssl':
    servername        => $::fqdn,
    serveraliases     => ['katello'],
    docroot           => '/var/www',
    port              => 443,
    priority          => '05',
    options           => ['SymLinksIfOwnerMatch'],
    ssl               => true,
    ssl_cert          => $certs::ca_cert,
    ssl_key           => $certs::ca_key,
    ssl_ca            => $certs::ca_cert,
    ssl_verify_client => 'optional',
    ssl_options       => '+StdEnvVars',
    ssl_verify_depth  => '3',
    custom_fragment   => template('katello/etc/httpd/conf.d/05-foreman-ssl.d/katello.conf.erb',
                                  'katello_devel/_ssl_alias.erb'),
    ssl_proxyengine   => true,
  }

  apache::vhost { 'katello':
    servername      => $::fqdn,
    serveraliases   => ['katello'],
    docroot         => '/var/www/html',
    port            => 80,
    priority        => '05',
    options         => ['SymLinksIfOwnerMatch'],
    ssl             => false,
    custom_fragment => template('katello/etc/httpd/conf.d/05-foreman.d/katello.conf.erb',
                                'katello_devel/_http.conf.erb'),
  }


  User<|title == apache|>{groups +> $katello_devel::group}
}
