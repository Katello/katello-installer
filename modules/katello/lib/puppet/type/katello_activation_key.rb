require File.expand_path('../katello_common', __FILE__)

Puppet::Type.newtype(:katello_activation_key) do

  instance_eval(&Katello::COMMON_PARAMS)

  newparam(:name, :namevar => true)

  newparam(:product)
end
