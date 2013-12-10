module Puppet::Parser::Functions

  newfunction(:validate_present, :doc => <<-DOC
Validate that the values are not empty.
DOC
  ) do |args|

    args.each do |arg|
      raise Puppet::ParseError, "must be present" if arg.to_s.empty?
    end

    return true
  end

end
