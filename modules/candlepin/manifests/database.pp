# Candlepin Database Setup
class candlepin::database{

  case $candlepin::db_type {
    'postgresql': {
      class{'::candlepin::database::postgresql': }
    }
    'mysql': {
      class{'::candlepin::database::mysql': }
    }
    default: {
      err("Invalid db_type selected: ${candlepin::db_type}. Valid options are ['mysql','postgresql'].")
    }
  }

}
