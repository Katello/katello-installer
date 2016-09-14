# Pulp Node Install Packages
class pulp::child::install {
  package { [
    'pulp-katello',
    'pulp-nodes-child',
    'katello-agent']: }
}
