Facter.add(:mongodb_version) do
  setcode do
    commands = ["rpmquery --qf='%{version}-%{release}' mongodb",
                "repoquery --qf='%{version}-%{release}' mongodb",
                %[LC_ALL=en_US yum -e 0 -d 0 info mongodb | awk '/^Version/ { version=$3; } /^Release/ { print version "-" $3; exit }']]
    ret = nil
    commands.each do |command|
      version = `#{command} 2>&1`.chomp
      if $?.success? && !version.empty?
        ret = version
        break
      end
    end
    ret
  end
end
