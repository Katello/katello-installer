# server_ssl_crl is expected to be an absolute path or a blank string, not
# false. Katelllo isn't using a CRL, so this needs to be a blank string.
answers['foreman']['server_ssl_crl'] = ""
