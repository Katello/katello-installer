# Convert a pkcs12 key pair to a java keystore
define certs::ssltools::keytool::convert_pkcs12_to_jks( $keystore_alias, $dest_keystore, $src_keystore, $keystore_password, $src_keystore_password, $refreshonly = false){
  exec { $title:
    command     => "keytool -importkeystore -destkeystore ${dest_keystore} -srckeystore ${src_keystore} -srcstoretype pkcs12 -alias ${keystore_alias} -storepass ${keystore_password} -srcstorepass ${src_keystore_password} -noprompt",
    path        => ['/bin/', '/usr/bin'],
    refreshonly => $refreshonly,
  }
}
