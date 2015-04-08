forge 'https://forgeapi.puppetlabs.com'

#################################################################
# The Foreman part of Puppetfile (taken from foreman-installer #
#################################################################

# Dependencies
mod 'puppetlabs-postgresql', :git => 'https://github.com/puppetlabs/puppetlabs-postgresql'
mod 'puppetlabs-mysql', :git => 'https://github.com/puppetlabs/puppetlabs-mysql', :ref => '2.2.0'
mod 'puppetlabs-firewall', :git => 'https://github.com/puppetlabs/puppetlabs-firewall', :ref => '1.0.0'
mod 'puppetlabs-vcsrepo'
mod 'puppetlabs-apache'

mod 'theforeman-concat_native', :git => 'https://github.com/theforeman/puppet-concat'
mod 'theforeman-dhcp', :git => 'https://github.com/theforeman/puppet-dhcp'
# Locked to commit - can't advance to 2.0.1 nor go back to 1.4
mod 'theforeman-dns', :git => 'https://github.com/theforeman/puppet-dns', :ref => '43bec3167ada475ed374a8d3db0c13164697129b'
mod 'theforeman-git', :git => 'https://github.com/theforeman/puppet-git'
mod 'theforeman-tftp', :git => 'https://github.com/theforeman/puppet-tftp'

mod 'theforeman-foreman', :git => 'https://github.com/theforeman/puppet-foreman'
mod 'theforeman-foreman_proxy', :git => 'https://github.com/theforeman/puppet-foreman_proxy'
mod 'theforeman-puppet', :git => 'https://github.com/theforeman/puppet-puppet'

###########################################################
# Katello part of Puppefile (taken from foreman-installer #
###########################################################

# Katello specific modules
mod 'katello-common', :git => 'https://github.com/Katello/puppet-common'
mod 'katello-candlepin', :git => 'https://github.com/Katello/puppet-candlepin'
mod 'katello-gutterball', :git => 'https://github.com/Katello/puppet-gutterball'
mod 'katello-capsule', :git => 'https://github.com/Katello/puppet-capsule'
mod 'katello-certs', :git => 'https://github.com/Katello/puppet-certs'
mod 'katello-elasticsearch', :git => 'https://github.com/Katello/puppet-elasticsearch'
mod 'katello-katello', :git => 'https://github.com/Katello/puppet-katello'
mod 'katello-pulp', :git => 'https://github.com/Katello/puppet-pulp', :ref => '0.1.0'
mod 'katello-crane', :git => 'https://github.com/Katello/puppet-crane'
mod 'katello-qpid', :git => 'https://github.com/Katello/puppet-qpid'
mod 'katello-service_wait', :git => 'https://github.com/Katello/puppet-service_wait'
mod 'puppetlabs-mongodb', :git => 'https://github.com/puppetlabs/puppetlabs-mongodb'

# Katello devel specific modules
mod 'katello-katello_devel', :git => 'https://github.com/Katello/puppet-katello_devel'
