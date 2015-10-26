module Puppet::Parser::Functions

  newfunction(:validate_file_exists, :doc => <<-DOC
Validate that the file exists.

This function can work only when running puppet apply.
# TODO:
Find a way how to skip it for puppetmaster scenario.
DOC
  ) do |files|

    files.each do |file|
      raise Puppet::ParseError, "#{file} does not exist" unless File.exist?(file)
    end

    true
  end

end
