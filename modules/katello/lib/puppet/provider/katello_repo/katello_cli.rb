require File.expand_path('../../katello_cli', __FILE__)

Puppet::Type.type(:katello_repo).provide(:katello_cli, :parent => Puppet::Provider::KatelloCli) do

  def exists?
    # we always upload when notified
    false
  end

  def create
    ensure_org
    ensure_provider
    ensure_product
    ensure_repo
    ensure_files
  end

  private

  def ensure_org
    exists = katello_list("org", "list").any? do |info|
      info[1] == resource[:org]
    end
    unless exists
      katello("org", "create", "--name", resource[:org])
    end
  end

  def ensure_provider
    exists = katello_list("provider", "list", "--org", resource[:org]).any? do |info|
      info[1] == resource[:repo_provider]
    end
    unless exists
      katello("provider",
              "create",
              "--org", resource[:org],
              "--name", resource[:repo_provider])
    end
  end

  def ensure_product
    exists = katello_list("product", "list", "--org", resource[:org]).any? do |info|
      info[1] == resource[:product]
    end
    unless exists
      katello("product",
              "create",
              "--org", resource[:org],
              "--provider", resource[:repo_provider],
              "--name", resource[:product])
    end
  end

  def ensure_repo
    exists = katello_list("repo", "list",
                          "--org", resource[:org],
                          "--product", resource[:product]).any? do |info|
      info[1] == resource[:repo]
    end
    unless exists
      katello("repo",
              "create",
              "--org", resource[:org],
              "--product", resource[:product],
              "--name", resource[:repo])
    end
  end

  def ensure_files
    Dir.glob(resource[:package_files]).each do |file|
       katello("repo", "content_upload",
               "--org", resource[:org],
               "--product", resource[:product],
               "--repo", resource[:repo],
               "--filepath", file,
               "--content_type", "yum")
    end
  end

end
