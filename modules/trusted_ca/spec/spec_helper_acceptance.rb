require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    install_puppet
  end

  hosts.each do |host|
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      # Can't we all set our hostname the same way?
      if fact('osfamily') == 'RedHat'
        if fact('operatingsystemmajrelease') == '6'
          shell("echo \"NETWORKING=yes\nHOSTNAME=#{host}.example.com\" > /etc/sysconfig/network")
          shell("hostname #{host}.example.com")
        elsif fact('operatingsystemmajrelease') == '7'
          shell("echo #{host}.example.com > /etc/hostname")
        end
        shell('/etc/init.d/network restart')
      elsif fact('osfamily') == 'Debian'
        shell("echo #{host}.example.com > /etc/hostname")
        if fact('operatingsystemrelease') == '12.04'
          shell("/etc/init.d/hostname restart")
        elsif fact('operatingsystemrelease') == '14.04'
          shell("hostname #{host}.example.com")
        end
      end

      #module and dependencies
      copy_module_to(host, :source => proj_root, :module_name => 'trusted_ca')
      on host, puppet('module', 'install', 'puppetlabs/concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs/stdlib'), { :acceptable_exit_codes => [0,1] }

      # testing dependencies
      on host, puppet('module', 'install', 'puppetlabs/apache'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs/java'), { :acceptable_exit_codes => [0,1] }
      scp_to(host, File.expand_path(File.join(File.dirname(__FILE__), 'acceptance', 'helpers', 'SSLPoke.class')), '/root/SSLPoke.class')
      scp_to(host, File.expand_path(File.join(File.dirname(__FILE__), 'acceptance', 'helpers', 'gen_cert.sh')), '/root/gen_cert.sh')
      shell('chmod a+x /root/gen_cert.sh')
      shell('/root/gen_cert.sh')
      shell("sed -ri 's/#{host}/#{host}.example.com #{host}/' /etc/hosts")
    end
  end
end
