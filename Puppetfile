forge 'https://forgeapi.puppetlabs.com'

#################################################################
# The Foreman part of Puppetfile (taken from foreman-installer #
#################################################################

# Dependencies
mod 'puppetlabs/apache',        '< 1.6.0'
mod 'puppetlabs/concat',        '< 1.3.0'
mod 'puppetlabs/mysql',         '< 3.5.0'
mod 'puppetlabs/postgresql',    '< 4.4.0'
mod 'puppetlabs/puppetdb',      '< 4.4.0'
mod 'puppetlabs/stdlib',        '< 5.0.0'
mod 'theforeman/dhcp',          '>= 2.0.0 < 2.1.0'
mod 'theforeman/dns',           '>= 3.0.0 < 3.1.0'
mod 'theforeman/git',           '>= 1.4.0 < 1.5.0'
mod 'theforeman/tftp',          '>= 1.5.0 < 1.6.0'

# Top-level modules
mod 'theforeman/foreman',       '>= 4.0.0 < 4.1.0'
mod 'theforeman/foreman_proxy', '>= 2.3.0 < 2.4.0'
mod 'theforeman/puppet',        '>= 4.0.0 < 4.1.0'


###########################################################
# Katello part of Puppefile                               #
###########################################################

# Dependencies
mod 'puppetlabs-mongodb',       '< 1.0.0'
mod 'katello-qpid',             '>= 1.0.0 < 1.1.0'
mod 'katello-pulp',             '>= 0.1.2 < 0.2.0'
mod 'katello-service_wait',     '>= 0.1.0 < 0.2.0'
mod 'katello-candlepin',        '>= 0.1.0 < 0.2.0'
mod 'katello-elasticsearch',    '>= 0.1.0 < 0.2.0'
mod 'katello-crane',            '>= 0.1.0 < 0.2.0'
mod 'katello-common',           '>= 0.1.0 < 0.2.0'
mod 'katello-gutterball',       '>= 0.1.0 < 0.2.0'

# Top-level modules
mod 'katello-katello',          '>= 1.0.0 < 1.1.0'
mod 'katello-capsule',          '>= 0.2.0 < 0.3.0'
mod 'katello-certs',            '>= 0.1.0 < 0.2.0'

# Katello devel specific modules
mod 'katello-katello_devel', :git => 'https://github.com/Katello/puppet-katello_devel'
