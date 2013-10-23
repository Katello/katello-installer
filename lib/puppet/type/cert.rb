require File.expand_path('../certs_common', __FILE__)

Puppet::Type.newtype(:cert) do
  desc 'ca signed cert'

  instance_eval(&Certs::CERT_COMMON_PARAMS)

  newparam(:hostname)

  newparam(:ca) do
    validate do |value|
      unless value.is_a?(Puppet::Resource) && value.resource_type.name == :ca
        raise ArgumentError, "Expected Ca resource"
      end
    end
  end

  newparam(:purpose) do
    defaultto 'server'
  end

  autorequire(:ca) do
    if @parameters.has_key?(:ca)
      @parameters[:ca].value.to_hash[:name]
    end
  end

end
