answers['katello']['candlepin_oauth_key'] = answers['katello'].delete('oauth_key') if answers['katello']['oauth_key']
answers['katello']['candlepin_oauth_secret'] = answers['katello'].delete('oauth_secret') if answers['katello']['oauth_secret']
