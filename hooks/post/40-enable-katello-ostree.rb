# Run pulp-manage-db if --katello-enable-ostree=true or --katello-devel-enable-ostree=true

ostree_enabled = @kafo.param('katello', 'enable_ostree') ?  @kafo.param('katello', 'enable_ostree').value : false
ostree_devel_enabled = @kafo.param('katello_devel', 'enable_ostree') ? @kafo.param('katello_devel', 'enable_ostree').value : false

if ostree_enabled || ostree_devel_enabled
  Kafo::Helpers.execute('katello-service stop --only pulp_workers,pulp_resource_manager,pulp_celerybeat')
  Kafo::Helpers.execute('su - apache -s /bin/bash -c pulp-manage-db')
  Kafo::Helpers.execute('katello-service start --only pulp_workers,pulp_resource_manager,pulp_celerybeat')
end
