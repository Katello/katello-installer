# hook to create pulp CA on EL6 if not present

if File.file?('/etc/pki/pulp/ca.crt') && File.file?('/etc/pki/pulp/ca.key')
  logger.info 'Pulp CA is already present, skipping'
else
  logger.warn 'Pulp CA is not present, creating.'
  `pulp-gen-ca-certificate`
end
