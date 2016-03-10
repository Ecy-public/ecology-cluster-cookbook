include_recipe 'ecology-cluster::default'

include_recipe 'nfs::server'

nfs_export '/home' do
  network '*'
  writeable true
  sync true
  options ['no_root_squash', 'insecure']
end
