def install_syspaths
  Kafo::Helpers.executs('rpm -qa | grep rh-mongodb34-syspaths')
  if $?.success?
    logger.info 'rh-mongodb34-syspaths already installed, skipping.'
  else
    logger.info 'rh-mongodb34-syspaths not present, installing.'
    Kafo::Helpers.execute('yum install -y -q rh-mongodb34-syspaths')
  end
end

install_syspaths
