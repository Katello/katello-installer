# gutterball config
class katello::plugin::gutterball::config(
    $foreman_user  = 'foreman',
    $foreman_group = 'foreman',
    $foreman_plugins_dir = '/etc/foreman/plugins',
    $url = "https://${::fqdn}:8443/gutterball",
  ){

  file { "${foreman_plugins_dir}/gutterball.yaml":
    content => template('katello/plugin/gutterball/gutterball.yaml.erb'),
    owner   => $foreman_user,
    group   => $foreman_group,
    mode    => '0644',
  }
}
