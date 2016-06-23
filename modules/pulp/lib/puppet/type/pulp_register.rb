Puppet::Type.newtype(:pulp_register) do
  @doc = <<-EOT
  EOT

  autorequire(:service) do
    ['goferd']
  end

  ensurable do
    desc <<-EOS
      Register/unregister a pulp consumer.
    EOS

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    desc "uniquely identifies the consumer; only alphanumeric, ., -, and _ allowed"
    isnamevar
  end

  newparam(:user) do
    defaultto 'admin'
  end

  newparam(:pass) do
    defaultto 'admin'
  end

  newparam(:keys) do
    desc "exchange public keys with the server"
    defaultto false
  end

  newproperty(:display_name) do
    desc "user-readable display name for the consumer"
    defaultto false
  end

  newproperty(:description) do
    desc "user-readable description for the consumer"
    defaultto false
  end

  newproperty(:note) do
    desc "note"
    defaultto false
  end

end
