if answers['foreman::cli'].is_a? Hash # If user has already specified options, set the SSL CA file
  answers['foreman::cli']['ssl_ca_file'] = '/etc/pki/katello/certs/katello-server-ca.crt'
elsif answers['foreman::cli'] # Otherwise set the SSL CA file only if foreman::cli is still enabled
  answers['foreman::cli'] = {'ssl_ca_file' => '/etc/pki/katello/certs/katello-server-ca.crt'}
end
