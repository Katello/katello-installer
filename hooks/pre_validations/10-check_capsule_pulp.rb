def error(message)
  say message
  logger.error message
  kafo.class.exit 101
end

if param('capsule', 'pulp') && param('capsule', 'pulp').value
  if system("rpm -q katello &>/dev/null")
    error "the pulp node can't be installed on a machine with #{Kafo::Helpers.product_name} master"
  end

  if system("(rpm -q ipa-server || rpm -q freeipa-server) &>/dev/null")
    error "the pulp node can't be installed on a machine with IPA"
  end

  unless system("subscription-manager identity &>/dev/null && ! grep -q subscription.rhn.redhat.com /etc/rhsm/rhsm.conf &> /dev/null")
    error "The system has to be registered to a #{Kafo::Helpers.product_name} instance before installing the node"
  end
end
