# Candlepin Database Setup using Mysql
class candlepin::database::mysql {


  $db_dialect = 'org.hibernate.dialect.MySQLDialect'
  $db_quartz_dialect = 'org.quartz.impl.jdbcjobstore.StdJDBCDelegate'
  $db_driver = 'com.mysql.jdbc.Driver'
  $db_type = $::candlepin::db_type
  $db_host = $::candlepin::db_host
  $db_port = pick($::candlepin::db_port, 3306)
  $db_name = $::candlepin::db_name
  $db_user = $::candlepin::db_user
  $db_password = $::candlepin::db_password
  $enable_hbm2ddl_validate = $::candlepin::enable_hbm2ddl_validate

  concat::fragment{'Mysql Database Configuration':
    target  => $::candlepin::candlepin_conf_file,
    content => template('candlepin/_candlepin_database.conf.erb'),
  }

}
