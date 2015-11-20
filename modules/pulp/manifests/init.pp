# == Class: pulp
#
# Install and configure pulp
#
# === Parameters:
# $version::                    pulp package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $oauth_key::                  string; key to enable OAuth style authentication
#
# $oauth_secret::               string; shared secret that can be used for OAuth style
#                               authentication
#
# $oauth_enabled::              boolean; controls whether OAuth authentication is enabled
#
# $messaging_url::              the url used to contact the broker: <protocol>://<host>:<port>/<virtual-host>
#                               Supported <protocol>  values are 'tcp' or 'ssl' depending on if SSL should be used or not.
#                               The <virtual-host> is optional, and is only applicable to RabbitMQ broker environments.
#
# $messaging_transport::        The type of broker you are connecting to. The default is 'qpid'.
#                               For RabbitMQ, 'rabbitmq' should be used.
#
# $messaging_ca_cert::          Absolute path to PEM encoded CA certificate file, used by Pulp to validate the identity
#                               of the broker using SSL.
#
# $messaging_client_cert::      Absolute path to PEM encoded file containing both the private key and
#                               certificate Pulp should present to the broker to be authenticated by the broker.
#
# $broker_url::                 A URL to a broker that Celery can use to queue tasks:
#                               qpid://<username>:<password>@<hostname>:<port>/
#
# $broker_use_ssl::             Require SSL if set to 'true', otherwise do not require SSL.
#
# $ca_cert::                    full path to the CA certificate that will be used to sign consumer
#                               and admin identification certificates; this must match the value of
#                               SSLCACertificateFile in /etc/httpd/conf.d/pulp.conf
#
# $ca_key::                     path to the private key for the above CA certificate
#
# $db_name::                    name of the database to use
#
# $db_seeds::                   comma-separated list of hostname:port of database replica seed hosts
#
# $db_username::                The user name to use for authenticating to the MongoDB server
#
# $db_password::                The password to use for authenticating to the MongoDB server
#
# $db_replica_set::             and set this value to the name of replica set configured in MongoDB,
#                               if one is in use
#
# $db_ssl::                     If True, create the connection to the server using SSL.
#
# $db_ssl_keyfile::             A path to the private keyfile used to identify the local connection against
#                               mongod. If included with the certfile then only the ssl_certfile is needed.
#
# $db_ssl_certfile::            The certificate file used to identify the local connection against mongod.
#
# $db_verify_ssl::              Specifies whether a certificate is required from the other side of the
#                               connection, and whether it will be validated if provided. If it is true, then
#                               the ssl_ca_certs parameter must point to a file of CA certificates used to
#                               validate the connection.
#
# $db_ca_path::                 The ca_certs file contains a set of concatenated "certification authority"
#                               certificates, which are used to validate certificates passed from the other end
#                               of the connection.
#
# $server_name::                hostname the admin client and consumers should use when accessing
#                               the server; if not specified, this is defaulted to the server's hostname
#
# $key_url::
#
# $ks_url::
#
# $debugging_mode::             boolean; toggles Pulp's debugging capabilities
#
# $log_level::                  The desired logging level. Options are: CRITICAL, ERROR, WARNING, INFO, DEBUG,
#                               and NOTSET. Pulp will default to INFO.
#
# $rsa_key::                    The RSA private key used for authentication.
#
# $rsa_pub::                    The RSA public key used for authentication.
#
# $https_cert::                 apache public certificate for ssl
#
# $https_key::                  apache private certificate for ssl
#
# $ssl_ca_cert::                full path to the CA certificate used to sign the Pulp
#                               server's SSL certificate; consumers will use this to verify the
#                               Pulp server's SSL certificate during the SSL handshake
#
# $consumers_crl::              Certificate revocation list for consumers which
#                               are no valid (have had their client certs
#                               revoked)
#
# $user_cert_expiration::       number of days a user certificate is valid
#
# $default_login::              default admin username of the Pulp server; this user will be
#                               the first time the server is started
#
# $default_password::           default password for admin when it is first created; this
#                               should be changed once the server is operational
#
# $repo_auth::                  Boolean to determine whether repos managed by
#                               pulp will require authentication. Defaults
#                               to true
#                               type:boolean
#
# $consumer_cert_expiration::   number of days a consumer certificate is valid
#
# $reset_cache::                Boolean to flush the cache. Defaults to false
#                               type:boolean
#
# $ssl_verify_client::          Enforce use of SSL authentication for yum repos access
#
# $serial_number_path::
#
# $consumer_history_lifetime::  number of days to store consumer events; events older
#                               than this will be purged; set to -1 to disable
#
# $messaging_url::              the url used to contact the broker: <protocol>://<host>:<port>/<virtual-host>
#                               Supported <protocol>  values are 'tcp' or 'ssl' depending on if SSL should be used or not.
#                               The <virtual-host> is optional, and is only applicable to RabbitMQ broker environments.
#
# $messaging_auth_enabled::     Message authentication enabled flag. The default is 'true' which enables authentication.
#                               To disable authentication, use 'false'.
#
# $messaging_topic_exchange::   The name of the exchange to use. The exchange must be a topic exchange. The
#                               default is 'amq.topic', which is a default exchange that is guaranteed to exist on a Qpid broker.
#
# $email_host::                 host name of the MTA pulp should relay through
#
# $email_port::                 destination port to connect on
#
# $email_from::                 the "From" address of each email the system sends
#
# $email_enabled::              boolean controls whether or not emails will be sent
#                               type:boolean
#
# $proxy_url::                  URL of the proxy server
#
# $proxy_port::                 Port the proxy is running on
#                               type:integer
#
# $proxy_username::             Proxy username for authentication
#
# $proxy_password::             Proxy password for authentication
#
# $num_workers::                Number of Pulp workers to use
#                               defaults to number of processors and maxs at 8
#                               type:integer
#
# $enable_rpm::                 Boolean to enable rpm plugin. Defaults
#                               to true
#                               type:boolean
#
# $enable_docker::              Boolean to enable docker plugin. Defaults
#                               to false
#                               type:boolean
#
# $enable_puppet::              Boolean to enable puppet plugin. Defaults
#                               to false
#                               type:boolean
#
# $enable_python::              Boolean to enable python plugin. Defaults
#                               to false
#                               type:boolean
#
# $enable_parent_node::         Boolean to enable pulp parent nodes. Defaults
#                               to false
#                               type:boolean
#
# $enable_http::                Boolean to enable http access to rpm repos. Defaults
#                               to false
#                               type:boolean
#
#
# $manage_httpd::               Boolean to install and configure the httpd server. Defaults
#                               to true
#                               type:boolean
#
# $manage_plugins_httpd::       Boolean whether to install the enabled pulp plugins apache configs
#                               even if $manage_httpd is false.  Defaults to true.
#                               type:boolean
#
# $manage_broker::              Boolean to install and configure the qpid or rabbitmq broker.
#                               Defaults to true
#                               type:boolean
#
# $manage_db::                  Boolean to install and configure the mongodb. Defaults
#                               to true
#                               type:boolean
#
# $node_certificate::           The absolute path to the node SSL certificate
#
# $node_verify_ssl::
#
# $node_server_ca_cert::
#
# $node_oauth_effective_user::
#
# $node_oauth_key::             The oauth key used to authenticate to the parent node
#
# $node_oauth_secret::          The oauth secret used to authenticate to the parent node
class pulp (
  $version                   = $pulp::params::version,
  $db_name                   = $pulp::params::db_name,
  $db_seeds                  = $pulp::params::db_seeds,
  $db_username               = $pulp::params::db_username,
  $db_password               = $pulp::params::db_password,
  $db_replica_set            = $pulp::params::db_replica_set,
  $db_ssl                    = $pulp::params::db_ssl,
  $db_ssl_keyfile            = $pulp::params::db_ssl_keyfile,
  $db_ssl_certfile           = $pulp::params::db_ssl_certfile,
  $db_verify_ssl             = $pulp::params::db_verify_ssl,
  $db_ca_path                = $pulp::params::db_ca_path,
  $server_name               = $pulp::params::server_name,
  $key_url                   = $pulp::params::key_url,
  $ks_url                    = $pulp::params::ks_url,
  $default_login             = $pulp::params::default_login,
  $default_password          = $pulp::params::default_password,
  $debugging_mode            = $pulp::params::debugging_mode,
  $log_level                 = $pulp::params::log_level,
  $rsa_key                   = $pulp::params::rsa_key,
  $rsa_pub                   = $pulp::params::rsa_pub,
  $ca_cert                   = $pulp::params::ca_cert,
  $ca_key                    = $pulp::params::ca_key,
  $https_cert                = $pulp::params::https_cert,
  $https_key                 = $pulp::params::https_key,
  $ssl_ca_cert               = $pulp::params::ssl_ca_cert,
  $user_cert_expiration      = $pulp::params::user_cert_expiration,
  $consumer_cert_expiration  = $pulp::params::consumer_cert_expiration,
  $serial_number_path        = $pulp::params::serial_number_path,
  $consumer_history_lifetime = $pulp::params::consumer_history_lifetime,
  $oauth_enabled             = $pulp::params::oauth_enabled,
  $oauth_key                 = $pulp::params::oauth_key,
  $oauth_secret              = $pulp::params::oauth_secret,
  $messaging_url             = $pulp::params::messaging_url,
  $messaging_transport       = $pulp::params::messaging_transport,
  $messaging_auth_enabled    = $pulp::params::messaging_auth_enabled,
  $messaging_ca_cert         = $pulp::params::messaging_ca_cert,
  $messaging_client_cert     = $pulp::params::messaging_client_cert,
  $messaging_topic_exchange  = $pulp::params::messaging_topic_exchange,
  $broker_url                = $pulp::params::broker_url,
  $broker_use_ssl            = $pulp::params::broker_use_ssl,
  $email_host                = $pulp::params::email_host,
  $email_port                = $pulp::params::email_port,
  $email_from                = $pulp::params::email_from,
  $email_enabled             = $pulp::params::email_enabled,
  $consumers_crl             = $pulp::params::consumers_crl,
  $reset_cache               = $pulp::params::reset_cache,
  $ssl_verify_client         = $pulp::params::ssl_verify_client,
  $repo_auth                 = $pulp::params::repo_auth,
  $proxy_url                 = $pulp::params::proxy_url,
  $proxy_port                = $pulp::params::proxy_port,
  $proxy_username            = $pulp::params::proxy_username,
  $proxy_password            = $pulp::params::proxy_password,
  $num_workers               = $pulp::params::num_workers,
  $enable_docker             = $pulp::params::enable_docker,
  $enable_rpm                = $pulp::params::enable_rpm,
  $enable_puppet             = $pulp::params::enable_puppet,
  $enable_python             = $pulp::params::enable_python,
  $enable_parent_node        = $pulp::params::enable_parent_node,
  $enable_http               = $pulp::params::enable_http,
  $manage_broker             = $pulp::params::manage_broker,
  $manage_db                 = $pulp::params::manage_db,
  $manage_httpd              = $pulp::params::manage_httpd,
  $manage_plugins_httpd      = $pulp::params::manage_plugins_httpd,
  $node_certificate          = $pulp::params::node_certificate,
  $node_verify_ssl           = $pulp::params::node_verify_ssl,
  $node_server_ca_cert       = $pulp::params::node_server_ca_cert,
  $node_oauth_effective_user = $pulp::params::node_oauth_effective_user,
  $node_oauth_key            = $pulp::params::node_oauth_key,
  $node_oauth_secret         = $pulp::params::node_oauth_secret,
) inherits pulp::params {
  validate_bool($repo_auth)
  validate_bool($reset_cache)
  validate_bool($enable_docker)
  validate_bool($enable_rpm)
  validate_bool($enable_puppet)
  validate_bool($enable_python)
  validate_bool($enable_http)
  validate_bool($manage_db)
  validate_bool($manage_broker)
  validate_bool($manage_httpd)
  validate_bool($manage_plugins_httpd)
  validate_bool($enable_parent_node)

  include ::mongodb::client
  include ::pulp::apache
  include ::pulp::database
  include ::pulp::broker
  class { '::pulp::install': } ->
  class { '::pulp::config': } ~>
  class { '::pulp::service': } ~>
  Service['httpd'] ->
  Class[pulp]
}
