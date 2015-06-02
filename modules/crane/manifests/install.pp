# Install Crane and dependencies
class crane::install {

  package{ ['python-crane']:
    ensure => installed,
  }
}
