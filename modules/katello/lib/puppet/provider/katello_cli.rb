require 'fileutils'

class Puppet::Provider::KatelloCli < Puppet::Provider

  initvars

  commands :katello_cli => 'katello'

  def katello(*args)
    katello_cli("--username", resource[:user],
                "--password", resource[:password],
               *args)
  end

  def katello_list(*args)
    args += ["-g", "-d", ";", "--noheading"]
    katello(*args).lines.map do |line|
      line.split(';')
    end
  end

end
