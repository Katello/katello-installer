require File.expand_path('../../katello_cli', __FILE__)

Puppet::Type.type(:katello_activation_key).provide(:katello_cli, :parent => Puppet::Provider::KatelloCli) do

  def exists?
    ak_exists? && product_included?
  end

  def create
    create_ak unless ak_exists?
    include_product unless product_included?
  end

  private

  def ak_exists?
    katello_list("activation_key", "list", "--org", resource[:org]).any? do |info|
      info[1] == resource[:name]
    end
  end

  def create_ak
    katello("activation_key",
            "create",
            "--org", resource[:org],
            "--name", resource[:name],
            "--environment", "Library",
            "--content_view", "Default Organization View")
  end

  def product_included?
    ak_info = katello("activation_key", "info",
                      "--org", resource[:org],
                      "--name", resource[:name])
    ak_info.include?(pool)
  end

  def include_product
    katello("activation_key", "update",
            "--org", resource[:org],
            "--name", resource[:name],
            "--add_subscription", pool)
  end

  def pool
    return @pool if defined? @pool
    subscription = katello_list("org", "subscriptions",
                           "--name", resource[:org]).find do |info|
      info[0] == resource[:product]
    end
    @pool = subscription ? subscription[2] : nil
  end

end
