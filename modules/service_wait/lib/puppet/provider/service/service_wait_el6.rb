# Manage services with ensuring it really runs

Puppet::Type.type(:service).provide :service_wait_el6, :parent => :redhat do
  desc "Manages services using `service-wait` command."

  commands :service => File.expand_path("../../../../../bin/service-wait", __FILE__)

  defaultfor :osfamily => [:redhat]
  confine :true => (Puppet[:operatingsystemrelease] =~ /^6.*/)
  confine :osfamily => /^(RedHat|Linux)/

  def self.specificity
    super + 10000
  end
end

