module Puppet::Parser::Functions
  # without setting pulp url using fqdn urls to pulp repo in TDL
  # manifests are not usable
  newfunction(:subsystem_url, :type => :rvalue) do |args|
    host = lookupvar("::fqdn")
    host = "localhost" if host.nil? || host.empty?
    path = args.first
    "https://#{host}/#{path}".downcase
  end
end
