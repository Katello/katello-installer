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
app_option(
  '--certs-skip-check',
  :flag,
  "This option will cause skipping the certificates sanity check. Use with caution",
  :default => false
)
