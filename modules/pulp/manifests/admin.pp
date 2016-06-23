#
# == Class: pulp::admin
#
# Install and configure Pulp admin
#
# === Parameters:
#
# $version::                       pulp admin package version, it's passed to ensure parameter of package resource
#                                  can be set to specific version number, 'latest', 'present' etc.
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
# $ca_path::                       This is a path to a file of concatenated trusted CA certificates, or to a directory of trusted
#                                  CA certificates (with openssl-style hashed symlinks, one certificate per file).
#
# $upload_chunk_size::             upload_chunk_size
#                                  type:integer
#
# $role::                          The client role.
#
# $extensions_dir::                The location of admin client extensions.
#
# $id_cert_dir::                   The location of the directory where the Pulp user ID certificate is stored.
#
# $id_cert_filename::              The name of the file containing the PEM encoded client private key and X.509
#                                  certificate. This file is downloaded and stored here during login.
#
# $upload_working_dir::            Directory where status files for in progress uploads will be stored
#
# $log_filename::                  The location of the admin client log file.
#
# $call_log_filename::             If present, the raw REST responses will be logged to the given file.
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
# $enable_puppet::                 Install puppet extension. Defaults to false.
#                                  type:boolean
#
# $enable_docker::                 Install docker extension. Defaults to false.
#                                  type:boolean
#
# $enable_nodes::                  Install nodes extension. Defaults to false.
#                                  type:boolean
#
# $enable_python::                 Install python extension. Defaults to false.
#                                  type:boolean
#
# $enable_ostree::                 Install ostree extension. Defaults to false.
#                                  type:boolean
#
# $enable_rpm::                    Install rpm extension. Defaults to true.
#                                  type:boolean
#
# $puppet_upload_working_dir::     Directory where status files for in progress uploads will be stored
#
# $puppet_upload_chunk_size::      Maximum amount of data (in bytes) sent for an upload in a single request
#                                  type:integer
#
class pulp::admin (
  $version                   = $pulp::admin::params::version,
  $host                      = $pulp::admin::params::host,
  $port                      = $pulp::admin::params::port,
  $api_prefix                = $pulp::admin::params::api_prefix,
  $verify_ssl                = $pulp::admin::params::verify_ssl,
  $ca_path                   = $pulp::admin::params::ca_path,
  $upload_chunk_size         = $pulp::admin::params::upload_chunk_size,
  $role                      = $pulp::admin::params::role,
  $extensions_dir            = $pulp::admin::params::extensions_dir,
  $id_cert_dir               = $pulp::admin::params::id_cert_dir,
  $id_cert_filename          = $pulp::admin::params::id_cert_filename,
  $upload_working_dir        = $pulp::admin::params::upload_working_dir,
  $log_filename              = $pulp::admin::params::log_filename,
  $call_log_filename         = $pulp::admin::params::call_log_filename,
  $poll_frequency_in_seconds = $pulp::admin::params::poll_frequency_in_seconds,
  $enable_color              = $pulp::admin::params::enable_color,
  $wrap_to_terminal          = $pulp::admin::params::wrap_to_terminal,
  $wrap_width                = $pulp::admin::params::wrap_width,
  $enable_puppet             = $pulp::admin::params::enable_puppet,
  $enable_docker             = $pulp::admin::params::enable_docker,
  $enable_nodes              = $pulp::admin::params::enable_nodes,
  $enable_python             = $pulp::admin::params::enable_python,
  $enable_ostree             = $pulp::admin::params::enable_ostree,
  $enable_rpm                = $pulp::admin::params::enable_rpm,
  $puppet_upload_working_dir = $pulp::admin::params::puppet_upload_working_dir,
  $puppet_upload_chunk_size  = $pulp::admin::params::puppet_upload_chunk_size,
) inherits pulp::admin::params {
  validate_bool($enable_puppet)
  validate_bool($enable_docker)
  validate_bool($enable_nodes)
  validate_bool($enable_python)
  validate_bool($enable_ostree)
  validate_bool($enable_rpm)

  validate_bool($verify_ssl)
  validate_bool($enable_color)
  validate_bool($wrap_to_terminal)

  class { '::pulp::admin::install': } ~>
  class { '::pulp::admin::config': }
}
