PUPPET_UPGRADE_COMPLETE = '/etc/foreman-installer/.puppet_5_upgrade'.freeze

def puppet5_available?
  return true if `rpm -q puppet-agent --queryformat=%{version}`.start_with?('5.')

  yum_info = `yum info puppet-agent`

  available = yum_info.split('Available Packages')[1]
  return false if available.nil?

  version = available.split(/Version/)[1].split("\n")[0]
  version = version.delete(':').strip
  version.start_with?('5.')
end

def puppet_upgrade_complete?
  File.exist?(PUPPET_UPGRADE_COMPLETE)
end

if app_value(:upgrade_puppet) && !puppet_upgrade_complete?
  if [0, 2].include? @kafo.exit_code
    File.open(PUPPET_UPGRADE_COMPLETE, 'w') do |file|
      file.write("Puppet 4 to 5 upgrade completed on #{Time.now}")
    end
  end
end

if !app_value(:upgrade_puppet) && !puppet_upgrade_complete? && puppet5_installed?
  File.open(PUPPET_UPGRADE_COMPLETE, 'w') do |file|
    file.write("No Puppet 4 to 5 upgrade performed. Puppet 5 installed on #{Time.now}.")
  end
end
