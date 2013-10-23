require File.expand_path('../katello_common', __FILE__)

Puppet::Type.newtype(:katello_repo) do

  instance_eval(&Katello::COMMON_PARAMS)

  newparam(:repo, :namevar => true)

  newparam(:repo_provider)

  newparam(:product)

  newparam(:package_files)
end
