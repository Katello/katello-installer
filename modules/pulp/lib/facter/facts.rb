Facter.add(:mongodb_version) do
  setcode do
    ENV['LC_ALL'] = 'en_US'
    commands = [
      "rpmquery --qf='%{version}-%{release}' mongodb",
      "repoquery --qf='%{version}-%{release}' mongodb",
      %[yum -e 0 -d 0 info mongodb 2>&1 | awk '/^Version/ { version=$3; } /^Release/ { print version "-" $3; exit }']
    ]
    ret = nil
    commands.each do |command|
      exe = command.partition(' ').first
      if system("which #{exe} > /dev/null 2>&1")
        version = `#{command} 2> /dev/null`.chomp
        if $?.success? && !version.empty?
          ret = version
          break
        end
      end
    end
    ret
  end
end
