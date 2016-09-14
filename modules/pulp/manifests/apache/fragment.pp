# provides the ability to specify fragments for the ssl 
#   virtual host defined for a Pulp server
#
#  === Parameters:
#
#  $ssl_content:: content of the ssl virtual host fragment
define pulp::apache::fragment(
  $ssl_content,
  $order       = 15,
) {

  validate_string($ssl_content)

  concat::fragment { $name:
    target  => '05-pulp-https.conf',
    content => $ssl_content,
    order   => $order,
  }

}
