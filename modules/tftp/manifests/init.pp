class tftp {
  include tftp::params
  include tftp::install
  include tftp::config
  include tftp::service

  Class['tftp::params']~>
  Class['tftp::install']~>
  Class['tftp::config']~>
  Class['tftp::service']
}
