answers['foreman'] = {} unless answers['foreman'].is_a?(Hash)
answers['foreman']['client_ssl_cert'] = '/etc/pki/katello/certs/katello-apache.crt'
answers['foreman']['client_ssl_key'] = '/etc/pki/katello/private/katello-apache.key'
answers['foreman']['client_ssl_ca'] = '/etc/pki/katello/certs/katello-default-ca.crt'
