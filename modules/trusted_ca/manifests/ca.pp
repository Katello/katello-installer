# == Define: ca
#
# This define installs individual root CAs
#
#
# === Parameters
#
# [*source*]
#   String.  Path to the certificate PEM.
#   Must specify either content or source.
#   If source is specified, content is ignored.
#
# [*content*]
#   String.  Content of certificate in PEM format.
#   Must specify either content or source.
#   If source is specified, content is ignored.
#
# [*install_path*]
#   String.  Location to install trusted certificates
#
# [*certfile_suffix*]
#   String.  The suffix of the certificate to install.
#   Default is OS/Distribution dependent, i.e. 'crt' or 'pem'
#
# === Examples
#
# * Installation:
#     class { 'trusted_ca': }
#
#     trusted_ca::ca { 'example.org.local':
#       source  => puppet:///data/ssl/example.com.pem
#     }
#
#     trusted_ca::ca { 'example.net.local':
#       content  => hiera("example-net-x509")
#     }
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define trusted_ca::ca (
  $source          = undef,
  $content         = undef,
  $install_path    = $::trusted_ca::install_path,
  $certfile_suffix = $::trusted_ca::certfile_suffix,
) {

  if ! defined(Class['trusted_ca']) {
    fail('You must include the trusted_ca base class before using any trusted_ca defined resources')
  }

  if $source and $content {
    fail('You must not specify both $source and $content for trusted_ca defined resources')
  }

  if inline_template('<% if /\.#{@certfile_suffix}$/.match(@name) then %>yes<% else %>no<% end %>') == 'yes' {
    $_name = $name
  } else {
    $_name = "${name}.${certfile_suffix}"
  }


  if $source {

    if inline_template('<% if /\.#{@certfile_suffix}$/.match(@source) then %>yes<% else %>no<% end %>') == 'no' {
      fail("[Trusted_ca::Ca::${name}]: source must a PEM encoded file with the ${certfile_suffix} extension")
    }

    file { "${install_path}/${_name}":
      ensure => 'file',
      source => $source,
      notify => Exec["validate ${install_path}/${_name}"],
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
    }

  } elsif $content {

    validate_re($content, '^[A-Za-z0-9+/\n=-]+$', "[Trusted_ca::Ca::${name}]: content must a PEM encoded string")

    file { "${install_path}/${_name}":
      ensure  => 'file',
      content => $content,
      notify  => Exec["validate ${install_path}/${_name}"],
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
    }
  } else {
    fail('You must specify either $source and $content for trusted_ca defined resources')
  }

  # This makes sure the certificate is valid
  exec {"validate ${install_path}/${_name}":
    command     => "openssl x509 -in ${install_path}/${_name} -noout",
    logoutput   => on_failure,
    path        => $::trusted_ca::path,
    notify      => Exec['update_system_certs'],
    returns     => 0,
    refreshonly => true,
  }

}
