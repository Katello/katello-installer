# Imports a ca into a keystore
define certs::ssltools::keytool::import_ca($keystore, $password, $keystore_alias, $file){
  exec { $title:
    command => "keytool -import -v -keystore ${keystore} -storepass ${password} -alias ${keystore_alias} -file ${file} -noprompt",
    creates => $keystore,
    path    => ['/bin/', '/usr/bin'],
  }
}
