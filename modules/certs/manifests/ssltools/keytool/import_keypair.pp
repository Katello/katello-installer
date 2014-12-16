# import a x509 keypair into a jks
define certs::ssltools::keytool::import_keypair($keystore_alias, $keystore, $keystore_password, $cert, $key, $tmp_password_file){
  # Stupid keytool doesn't allow you to import a keypair.  You can only import a cert.  Hence, we have to
  # create the store as an PKCS12 and convert to JKS.  See http://stackoverflow.com/a/8224863

  $tmpkeystore = "/tmp/${keystore_alias}keystore.p12"
  exec{ "[${title}] signal import if pair has not been imported":
    command => 'echo importing keypair',
    unless  => "keytool -list -keystore ${keystore} -storepass ${keystore_password} -alias ${keystore_alias}",
    path    => ['/bin/', '/usr/bin'],
  } ~>
  certs::ssltools::openssl::pkcs12{ "[${title}] convert x509 cert and key to pkcs12":
    cert_name    => $keystore_alias,
    ca_cert      => $cert,
    ca_name      => 'root',
    ca_key       => $key,
    keystore_out => $tmpkeystore,
    password_out => $tmp_password_file,
    password_in  => $keystore_password,
    refreshonly  => true,
  } ->
  convert_pkcs12_to_jks{ "[${title}] convert tmp pkcs12 keystore to jks":
    keystore_alias        => $keystore_alias,
    dest_keystore         => $keystore,
    src_keystore          => $tmpkeystore,
    keystore_password     => $keystore_password,
    src_keystore_password => $keystore_password,
    refreshonly           => true,
  }
}
