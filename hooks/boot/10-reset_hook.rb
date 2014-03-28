# Add reset option
app_option(
  '--reset',
  :flag,
  "This option will drop the Katello database and clear all subsequent backend data stores." +
  "You will lose all data! Unfortunately we\n" +
  "can't detect a failure at the moment so you should verify the success\n" +
  'manually. e.g. dropping can fail when DB is currently in use.',
  :default => false
)
