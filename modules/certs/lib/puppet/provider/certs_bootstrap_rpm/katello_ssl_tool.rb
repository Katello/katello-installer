require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:certs_bootstrap_rpm).provide(:katello_ssl_tool) do

  commands :katello_certs_gen_rpm => 'katello-certs-gen-rpm'

  def run
    post_script_file = File.join(resource[:dir], 'rhsm-katello-reconfigure')
    File.open(post_script_file, 'w') { |f| f << resource[:bootstrap_script] }

    postun_script_file = File.join(resource[:dir], 'rhsm-katello-remove-reconfigure')
    File.open(postun_script_file, 'w') { |f| f << resource[:postun_script] }

    Dir.chdir(resource[:dir]) do
      katello_certs_gen_rpm('--name', resource[:name],
                            '--version', '1.0',
                            '--release', next_release,
                            '--packager', 'None',
                            '--vendor', 'None',
                            '--group', 'Applications/System',
                            '--summary', resource[:summary],
                            '--description', resource[:description],
                            '--requires', 'subscription-manager',
                            '--post', post_script_file,
                            '--postun', postun_script_file,
                            *resource[:files])
      if (rpm = last_rpm) && resource[:alias]
        File.delete(resource[:alias]) if File.exists?(resource[:alias])
        File.symlink(rpm, resource[:alias])
      end
      system('/sbin/restorecon ./*.rpm')
    end
  ensure
    File.delete(post_script_file) if File.exists?(post_script_file)
    File.delete(postun_script_file) if File.exists?(postun_script_file)
  end

  protected

  def last_rpm
    rpms = Dir.glob(File.join(resource[:dir], "#{resource[:name]}-*.noarch.rpm"))

    rpms = rpms.collect do |rpm|
      rpm_split = rpm.split("#{resource[:name]}-")[1].split('.noarch.rpm')[0]
      version = rpm_split.split('-')[0]
      release = rpm_split.split('-')[1]

      {'release' => release, 'rpm' => rpm}
    end

    rpm = rpms.sort { |a,b| a['release'].to_i <=> b['release'].to_i }.last
    rpm['rpm'] if rpm
  end

  def next_release
    if last_rpm
      last_rpm[/-(\d+).noarch.rpm$/, 1].to_i + 1
    else
      1
    end
  end

end
