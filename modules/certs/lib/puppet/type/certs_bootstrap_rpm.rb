Puppet::Type.newtype(:certs_bootstrap_rpm) do

  @doc = "Geneate certificates bootstrap rpm for the clietns

    This resource generates an rpm that can be distributed to the clients to set
    the subscription-manager to communicate with the server.

    It should be subcribed to the resource that represent the server CA,
    so that every time the resoruce is generated, a new bootstrap rpm version.

    When alias is specified, it symlinks the latest rpm version to this alias
    for easier redistribution.
  "

  desc 'Generates the rpm with certificates for boostraping the clients'
    newparam(:name, :namevar => true)

    newparam(:dir)

    newparam(:summary)

    newparam(:description)

    newparam(:bootstrap_script)

    newparam(:files)

    newparam(:alias)

    def refresh
      provider.run
    end
end
