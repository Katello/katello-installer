#
# == Class: pulp::consumer
#
# Install and configure Pulp consumers
#
# === Parameters:
#
# $ca_path::                       Path to use for the CA
#
# $version::                       pulp admin package version, it's passed to ensure parameter of package resource
#                                  can be set to specific version number, 'latest', 'present' etc.
#
# $enable_puppet::                 Install puppet extension. Only available on pulp 2.6 and higher
#                                  type:boolean
#
# $enable_nodes::                  Install nodes extension
#                                  type:boolean
#
# $enable_rpm::                    Install rpm extension
#                                  type:boolean
#
# $host::                          The pulp server hostname
#
# $port::                          The port providing the RESTful API
#                                  type:integer
#
# $api_prefix::                    The REST API prefix.
#
# $verify_ssl::                    Set this to False to configure the client not to verify that the server's SSL cert is signed by
#                                  a trusted authority
#                                  type:boolean
#
# $rsa_server_pub::                The pulp server public key used for authentication.
#
# $rsa_key::                       The RSA private key used for authentication.
#
# $rsa_pub::                       The RSA public key used for authentication.
#
# $role::                          The client role.
#
# $extensions_dir::                The location of consumer client extensions.
#
# $repo_file::                     The location of the YUM repository file managed by pulp.
#
# $mirror_list_dir::               The location of the directory containing YUM mirror list files that are managed by Pulp.
#
# $gpg_keys_dir::                  The location of downloaded GPG keys stored by Pulp. The path to the
#                                  keys stored here are referenced by Pulp's YUM repository file.
#
# $cert_dir::                      The location of downloaded X.509 certificates stored by Pulp. The path to
#                                  the certificates stored here are referenced by Pulp's YUM repository file.
#
# $id_cert_dir::                   The location of the directory where the Pulp consumer ID certificate is stored.
#
# $id_cert_filename::              The name of the file containing the PEM encoded consumer private key and X.509
#                                  certificate. This file is downloaded and stored here during registration.
#
# $reboot_permit::                 Permit reboots after package installs if requested.
#                                  type:boolean
#
# $reboot_delay::                  The reboot delay (minutes).
#                                  type:integer
#
# $logging_filename::              The location of the consumer client log file.
#
# $logging_call_log_filename::     If present, the raw REST responses will be logged to the given file.
#
# $poll_frequency_in_seconds::     Number of seconds between requests for any operation that repeatedly polls
#                                  the server for data.
#                                  type:integer
#
# $enable_color::                  Set this to false to disable all color escape sequences
#                                  type:boolean
#
# $wrap_to_terminal::              If wrap_to_terminal is true, any text wrapping will use the current width of
#                                  the terminal. If false, the value in wrap_width is used.
#                                  type:boolean
#
# $wrap_width::                    The number of characters written before wrapping to the next line.
#                                  type:integer
#
# $messaging_scheme::              The broker URL scheme. Either 'tcp' or 'ssl' can be used. The default is 'tcp'.
#
# $messaging_host::                The broker host (default: host defined in [server]).
#
# $messaging_port::                The broker port number. The default is 5672.
#                                  type:integer
#
# $messaging_transport::           The AMQP transport name. Valid options are 'qpid' or 'rabbitmq'. The default is 'qpid'.
#
# $messaging_cacert::              The (optional) absolute path to a PEM encoded CA certificate to validate the identity of the
#                                  broker.
#
# $messaging_clientcert::          The optional absolute path to PEM encoded key & certificate used to authenticate to the broker
#                                  with. The id_cert_dir and id_cert_filename are used if this is not defined.
#
# $profile_minutes::               The interval in minutes for reporting the installed content profiles.
#                                  type:boolean
#
# $package_profile_enabled::       Updates package profile information for a registered consumer on pulp server
#                                  type:boolean
#
# $package_profile_verbose::       Set logging level
#                                  type:integer
#
class pulp::consumer (
  $version                   = $pulp::consumer::params::version,
  $enable_puppet             = $pulp::consumer::params::enable_puppet,
  $enable_nodes              = $pulp::consumer::params::enable_nodes,
  $enable_rpm                = $pulp::consumer::params::enable_rpm,
  $host                      = $pulp::consumer::params::host,
  $port                      = $pulp::consumer::params::port,
  $api_prefix                = $pulp::consumer::params::api_prefix,
  $verify_ssl                = $pulp::consumer::params::verify_ssl,
  $ca_path                   = $pulp::consumer::params::ca_path,
  $rsa_server_pub            = $pulp::consumer::params::rsa_server_pub,
  $rsa_key                   = $pulp::consumer::params::rsa_key,
  $rsa_pub                   = $pulp::consumer::params::rsa_pub,
  $role                      = $pulp::consumer::params::role,
  $extensions_dir            = $pulp::consumer::params::extensions_dir,
  $repo_file                 = $pulp::consumer::params::repo_file,
  $mirror_list_dir           = $pulp::consumer::params::mirror_list_dir,
  $gpg_keys_dir              = $pulp::consumer::params::gpg_keys_dir,
  $cert_dir                  = $pulp::consumer::params::cert_dir,
  $id_cert_dir               = $pulp::consumer::params::id_cert_dir,
  $id_cert_filename          = $pulp::consumer::params::id_cert_filename,
  $reboot_permit             = $pulp::consumer::params::reboot_permit,
  $reboot_delay              = $pulp::consumer::params::reboot_delay,
  $logging_filename          = $pulp::consumer::params::logging_filename,
  $logging_call_log_filename = $pulp::consumer::params::logging_call_log_filename,
  $poll_frequency_in_seconds = $pulp::consumer::params::poll_frequency_in_seconds,
  $enable_color              = $pulp::consumer::params::enable_color,
  $wrap_to_terminal          = $pulp::consumer::params::wrap_to_terminal,
  $wrap_width                = $pulp::consumer::params::wrap_width,
  $messaging_scheme          = $pulp::consumer::params::messaging_scheme,
  $messaging_host            = $pulp::consumer::params::messaging_host,
  $messaging_port            = $pulp::consumer::params::messaging_port,
  $messaging_transport       = $pulp::consumer::params::messaging_transport,
  $messaging_cacert          = $pulp::consumer::params::messaging_cacert,
  $messaging_clientcert      = $pulp::consumer::params::messaging_clientcert,
  $profile_minutes           = $pulp::consumer::params::profile_minutes,
  $package_profile_enabled   = $pulp::consumer::params::package_profile_enabled,
  $package_profile_verbose   = $pulp::consumer::params::package_profile_verbose,
) inherits pulp::consumer::params {
  validate_bool($enable_puppet)
  validate_bool($enable_nodes)
  validate_bool($enable_rpm)

  validate_bool($verify_ssl)
  validate_bool($reboot_permit)
  validate_bool($enable_color)
  validate_bool($wrap_to_terminal)

  class { '::pulp::consumer::install': } ->
  class { '::pulp::consumer::config': } ~>
  class { '::pulp::consumer::service': }
}
