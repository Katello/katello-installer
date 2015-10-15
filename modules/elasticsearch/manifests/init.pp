# == Class: elasticsearch
#
# Install and configure Elasticsearch
#
# === Parameters:
#
# $min_mem::             The minimum memory Elasticsearch should use;
#                        default '256m'
#
# $max_mem::             The maximum memory Elasticsearch should use;
#                        default '256m'
#
# $reset_data::          Determines whether the Elasticsearch data should
#                        be reset; defaults to NONE
#
class elasticsearch (
  $min_mem = $elasticsearch::params::min_mem,
  $max_mem = $elasticsearch::params::max_mem,

  $reset_data = $elasticsearch::params::reset_data

  ) inherits elasticsearch::params {

  class { '::elasticsearch::install': } ~>
  class { '::elasticsearch::config': } ~>
  class { '::elasticsearch::service': } ->
  Class['elasticsearch']

}
