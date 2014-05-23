# Manage TFTP
class tftp inherits tftp::params {
  class {'tftp::install':} ->
  class {'tftp::config':} ~>
  class {'tftp::service':} ->
  Class['tftp']
}
