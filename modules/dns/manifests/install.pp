# Install dns service
class dns::install {
  ensure_packages([$dns::dns_server_package])
}
