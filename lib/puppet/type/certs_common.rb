module Certs

  CERT_COMMON_PARAMS = Proc.new do
    ensurable

    # make ensure present default
    define_method(:managed?) { true }

    newparam(:name, :namevar => true)

    newparam(:common_name)

    newparam(:email)

    newparam(:country)

    newparam(:state)

    newparam(:city)

    newparam(:org)

    newparam(:org_unit)

    newparam(:expiration)

    newparam(:generate)

    newparam(:regenerate)

    newparam(:deploy)
  end

  FILE_COMMON_PARAMS = Proc.new do
    ensurable

    newparam(:path, :namevar => true)

    # make ensure present default
    define_method(:managed?) { true }

    newparam(:cert) do
      # TODO: should be required
      validate do |value|
        unless value.is_a?(Puppet::Resource) && [:ca, :cert].include?(value.resource_type.name)
          raise ArgumentError, "Expected Cert or Ca resource"
        end
      end
    end

    autorequire(:file) do
      @parameters[:path]
    end

    autorequire(:cert) do
      # TODO: find better way how to determine the type
      if @parameters.has_key?(:cert) &&
            @parameters[:cert].value.resource_type.name == :cert
        @parameters[:cert].value.to_hash[:name]
      end
    end

    autorequire(:ca) do
      if @parameters.has_key?(:cert) &&
            @parameters[:cert].value.resource_type.name == :ca
        @parameters[:cert].value.to_hash[:name]
      end
    end

  end
end
