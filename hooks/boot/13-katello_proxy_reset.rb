# Add katello reset proxy option
app_option(
  '--katello-proxy-reset',
  :flag,
  "This option will reset the katello proxy paramaters back to an empty value.",
  :default => false
)
