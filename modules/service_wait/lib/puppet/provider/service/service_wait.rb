# Manage services with ensuring it really runs

Puppet::Type.type(:service).provide :service_wait, :parent => :redhat  do
  desc "Manages services using `service-wait` command."

  commands :service => File.expand_path("../../../../../bin/service-wait", __FILE__)

  defaultfor :osfamily => [:redhat]

end
