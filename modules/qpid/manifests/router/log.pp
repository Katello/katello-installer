# == Define: qpid::router::log
#
# Configure qpid router logging
#
# == Parameters
#
# $module::         Logging module to use
#
# $level::          Logging level to use (e.g., debug+, info+)
#
# $timestamp::      Enable timestamps
#                   type:boolean
#
# $output::         Log file location
#
define qpid::router::log(
  $module         = 'DEFAULT',
  $level          = 'info+',
  $timestamp      = true,
  $output         = '/var/log/qdrouterd.log',
){

  validate_bool($timestamp)
  validate_absolute_path($output)

  concat::fragment {"qdrouter+log_${title}.conf":
    target  => $qpid::router::config_file,
    content => template('qpid/router/log.conf.erb'),
    order   => '06',
  }

}
