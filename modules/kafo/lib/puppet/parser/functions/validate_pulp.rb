module Puppet::Parser::Functions

  newfunction(:validate_pulp, :doc => <<-DOC
Validate that the pulp node is not installed on Katello master.

This function can work only when running puppet apply.
# TODO:
Find a way how to skip it for puppetmaster scenario.
DOC
  ) do |args|
    install_pulp = args.first
    if install_pulp
      if system("rpm -q katello &>/dev/null")
        raise Puppet::ParseError, "the pulp node can't be installed on a machine with Katello master"
      end
    end
    return true
  end

end
