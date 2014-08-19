# Add options around regenerating certificates
app_option(
  '--certs-update-server',
  :flag,
  "This option will enforce an update of the HTTPS certificates",
  :default => false
)
app_option(
  '--certs-update-server-ca',
  :flag,
  "This option will enforce an update of the CA used for HTTPS certificates.",
  :default => false
)
app_option(
  '--certs-update-all',
  :flag,
  "This option will enforce an update of all the certificates for given host",
  :default => false
)
