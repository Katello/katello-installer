require File.expand_path('../../katello_ssl_tool', __FILE__)

Puppet::Type.type(:certs_bootstrap_rpm).provide(:katello_ssl_tool) do

  commands :katello_certs_gen_rpm => 'katello-certs-gen-rpm'

  def run
    post_script_file = File.join(resource[:dir], 'rhsm-katello-reconfigure')
    File.open(post_script_file, 'w') { |f| f << resource[:bootstrap_script] }

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
                            *resource[:files])
      if resource[:alias]
        File.delete(resource[:alias]) if File.exists?(resource[:alias])
        File.symlink(last_rpm, resource[:alias])
      end
      system('/sbin/restorecon ./*.rpm')
    end
  ensure
    File.delete(post_script_file) if File.exists?(post_script_file)
  end

  protected

  def last_rpm
    Dir.glob(File.join(resource[:dir], "#{resource[:name]}-*.noarch.rpm")).sort.last
  end

  def next_release
    if last_rpm
      last_rpm[/-(\d+).noarch.rpm$/, 1].to_i + 1
    else
      1
    end
  end

end
