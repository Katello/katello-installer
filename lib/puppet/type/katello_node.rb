Puppet::Type.newtype(:katello_node) do
  ensurable

  # make ensure present default
  def managed?
    true
  end

  newparam(:base_url, :namevar => true)
  newparam(:content)
end
