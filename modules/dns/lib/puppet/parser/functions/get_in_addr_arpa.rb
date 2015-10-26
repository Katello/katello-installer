module Puppet::Parser::Functions
  newfunction(:get_in_addr_arpa, :type => :rvalue) do |args|
    "#{args[0].split(".").reverse.join(".")}.in-addr.arpa"
  end
end
