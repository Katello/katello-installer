# Manage services with ensuring it really runs
Puppet::Type.type(:service).provide :service_wait, :parent => :systemd do
  desc "Manages services using `service-wait` command."

  commands :systemctl => File.expand_path("../../../../../bin/service-wait", __FILE__)

  defaultfor :osfamily => :redhat, :operatingsystemmajrelease => "7"

  def self.specificity
   # The specificity determines which provider wins at the end
   # https://github.com/puppetlabs/puppet/blob/3.4.2/lib/puppet/provider.rb#L333-L339
   # Workaround to make sure the service-wait will be always used.
   # The usual value for specificity is < 1000. Adding 10 000 should do
   # the trick
    super + 10000
  end
end

