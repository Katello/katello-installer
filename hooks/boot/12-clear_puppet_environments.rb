# Add reset option
app_option(
  '--clear-puppet-environments',
  :flag,
  'This option will clear all Puppet environments from disk located in \'/etc/puppet/environments/\'.',
  :default => false
)
