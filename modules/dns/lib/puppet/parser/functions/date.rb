module Puppet::Parser::Functions
  newfunction(:date, :type => :rvalue) do 
    Time.new.strftime('%s')
  end
end

