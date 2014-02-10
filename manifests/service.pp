# Pulp Master Service
class pulp::service {
  Service[httpd] ->
  Class['pulp::service']
}
