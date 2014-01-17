# Katello Config
class katello::config {
  include katello::params

  group { $katello::group:
    ensure => "present"
  } ~>

  user { $katello::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Katello',
    gid     => $katello::group,
    groups  => $katello::user_groups,
  }

  # this should be required by all classes that need to log there (one of these)
  file {
    $katello::params::log_base:
      owner => $katello::params::user,
      group => $katello::params::group,
      mode => '0750';
    # this is a symlink when called via katello-configure
    $katello::params::configure_log_base:
      owner => $katello::params::user,
      group => $katello::params::group,
      mode => '0750';
  }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner => $katello::params::user,
    group => $katello::user_groups,
    mode => '0644',
  }

  # create Rails logs in advance to get correct owners and permissions
  file {[
    "${katello::params::log_base}/production.log",
    "${katello::params::log_base}/production_sql.log",
    "${katello::params::log_base}/production_delayed_jobs.log",
    "${katello::params::log_base}/production_delayed_jobs_sql.log",
    "${katello::params::log_base}/production_orch.log",
    "${katello::params::log_base}/production_delayed_jobs_orch.log"]:
      owner => $katello::params::user,
      group => $katello::params::group,
      content => '',
      replace => false,
      mode => '0640',
  }

  file {
    "${katello::params::config_dir}/katello.yml":
      ensure => file,
      content => template("katello/${katello::params::config_dir}/katello.yml.erb"),
      owner => $katello::params::user,
      group => $katello::user_groups,
      mode => '0644',
      before => [Class['foreman::database'], Exec['foreman-rake-db:migrate']];

    '/etc/sysconfig/katello':
      content => template('katello/etc/sysconfig/katello.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644';

    '/etc/katello/client.conf':
      content => template('katello/etc/katello/client.conf.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644';
  }

  #File["/etc/sysconfig/katello"] ~> Exec["reload-apache"]
  #File["/etc/httpd/conf.d/katello.d"] ~>
  #File["/etc/httpd/conf.d/katello.d/katello.conf"] ~> Exec["reload-apache"]
  #File["/etc/httpd/conf.d/katello.conf"] ~> Exec["reload-apache"]

#  exec {"katello_db_printenv":
#    cwd         => $katello::params::katello_dir,
#    user        => $katello::params::user,
#    environment => "RAILS_ENV=${katello::params::environment}",
#    command     => "/usr/bin/env > ${katello::params::db_env_log}",
#    creates => "${katello::params::db_env_log}",
#    before  => Class["katello::service"],
#    require => $katello::params::deployment ? {
#                'katello' => [
#                  Class["candlepin::service"],
#                  Class["pulp::service"],
#                  Class["foreman"],
#                  File["${katello::params::log_base}"],
#                  File["${katello::params::log_base}/production.log"],
#                  File["${katello::params::log_base}/production_sql.log"],
#                  File["${katello::params::config_dir}/katello.yml"]
#                ],
#                'headpin' => [
#                  Class["candlepin::service"],
#                  Class["thumbslug::service"],
#                  Class["foreman"],
#                  File["${katello::params::log_base}"],
#                  File["${katello::params::config_dir}/katello.yml"]
#                ],
#                default => [],
#    },
#  }
#
#  if $katello::params::reset_data == 'YES' {
#    exec {"reset_katello_db":
#      command => "rm -f /var/lib/katello/db_seed_done; rm -f /var/lib/katello/db_migrate_done; service katello stop; service katello-jobs stop; test 1 -eq 1",
#      path    => "/sbin:/bin:/usr/bin",
#      before  => Exec["katello_migrate_db"],
#      notify  => Postgresql::Dropdb["$katello::params::db_name"],
#    }
#    postgresql::dropdb {$katello::params::db_name:
#      logfile => "${katello::params::configure_log_base}/drop-postgresql-katello-database.log",
#      require => [ Postgresql::Createuser[$katello::params::db_user], File["${katello::params::configure_log_base}"] ],
#      before  => Exec["katello_migrate_db"],
#      refreshonly => true,
#      notify  => [
#        Postgresql::Createdb[$katello::params::db_name],
#        Exec["katello_db_printenv"],
#        Exec["katello_migrate_db"],
#        Exec["katello_seed_db"],
#      ],
#    }
#  }
#
#  # during first installation we mark all 'once'  upgrade scripts as executed
#  exec {"update_upgrade_history":
#    cwd     => "${katello::params::katello_upgrade_scripts_dir}",
#    command => "grep -E '#.*run:.*once' * | awk -F: '{print \$1}' > ${katello::params::katello_upgrade_history_file}",
#    creates => "${katello::params::katello_upgrade_history_file}",
#    path    => "/bin",
#    before  => Class["katello::service"],
#  }
#
#  # Headpin does not care about pulp
#  #case $katello::params::deployment {
#  #  'katello': {
#  #    Class["candlepin::config"] -> File["/etc/pulp/server.conf"]
#  #    Class["candlepin::config"] -> File["/etc/pulp/repo_auth.conf"]
#  #    Class["candlepin::config"] -> File["/etc/pki/pulp/content/pulp-global-repo.ca"]
#  #  }
#  #  default : {}
#  #}

}
