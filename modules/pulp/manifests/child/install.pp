# Pulp Node Install Packages
class pulp::child::install {
  package { [
    'pulp-katello-plugins',
    'pulp-nodes-child',
    'pulp-puppet-plugins',
    'katello-agent']: }
}
