module Certs

  CERT_COMMON_PARAMS = Proc.new do
    ensurable

    # make ensure present default
    define_method(:managed?) { true }

    newparam(:name, :namevar => true)

    newparam(:custom_pubkey)

    newparam(:custom_privkey)

    newparam(:custom_req)

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

    newparam(:password_file)

    newparam(:ca) do
      validate do |value|
        if value && !value.is_a?(Puppet::Resource) || value.resource_type.name != :ca
          raise ArgumentError, "Expected Ca resource"
        end
      end
    end

    autorequire(:ca) do
      if @parameters.has_key?(:ca)
        @parameters[:ca].value.to_hash[:name]
      end
    end
  end

  FILE_COMMON_PARAMS = Proc.new do
    ensurable

    newparam(:path, :namevar => true)

    newparam(:password_file)

    # make ensure present default
    define_method(:managed?) { true }

    newparam(:key_pair) do
      validate do |value|
        unless value.is_a?(Puppet::Resource) && (value.resource_type.name == :ca || value.resource_type.name == :cert)
          raise ArgumentError, "Expected Ca or Cert resource"
        end
      end
    end

    define_method(:autorequire_cert) do |type|
      if @parameters.has_key?(:key_pair) && @parameters[:key_pair].value.type == type
        @parameters[:key_pair].value.to_hash[:name]
      end
    end

    autorequire(:cert) do
      autorequire_cert('Cert')
    end

    autorequire(:ca) do
      autorequire_cert('Ca')
    end

    autorequire(:file) do
      @parameters[:path]
    end

  end
end
