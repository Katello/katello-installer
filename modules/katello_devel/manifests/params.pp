# Katello development parameters
class katello_devel::params () inherits ::katello::params {
  $user = undef

  $use_passenger = false

  $oauth_key    = 'katello'
  $oauth_secret = cache_data('katello_devel_oauth_secret', random_password(32))

  $db_type = 'sqlite'

  $deployment_dir = 'UNSET'

  $post_sync_token = 'test'

  $use_rvm = true
  $rvm_ruby = '1.9.3-p448'

  $initial_organization = 'Default Organization'
  $initial_location = 'Default Location'
  $admin_password = 'changeme'

}
