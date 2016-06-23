module Puppet::Parser::Functions

  newfunction(:file_exists, :type => :rvalue, :doc => <<-DOC
    Check whether a file exists or not.
    DOC
  ) do |args|
     return File.exists?(args[0])
  end

end
