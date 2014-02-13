module Puppet::Parser::Functions

  newfunction(:validate_file_exists, :doc => <<-DOC
Validate that the file exists.

This function can work only when running puppet apply.
# TODO:
Find a way how to skip it for puppetmaster scenario.
DOC
  ) do |args|

    args.each do |arg|
      raise Puppet::ParseError, "does not exist" unless File.exist?(arg)
    end

    return true
  end

end
