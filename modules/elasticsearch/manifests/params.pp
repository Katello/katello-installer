# Default params for Elasticsearch
class elasticsearch::params {
  # memory setting
  $min_mem = '256m'
  $max_mem = '256m'

  # database reinitialization flag
  $reset_data = 'NONE'
}
