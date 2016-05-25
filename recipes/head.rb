package 'lvm2'
lvm_volume_group 'vg00' do
  physical_volumes node['ecology-cluster']['home-devices']
  wipe_signatures true

  logical_volume 'home' do
    size        '100%VG'
    filesystem  'xfs'
    mount_point location: '/home', options: 'noatime,nodiratime'
  end
end

include_recipe 'ecology-cluster::default'
include_recipe 'nfs::server'

nfs_export '/home' do
  network '*'
  writeable true
  sync true
  options ['no_root_squash', 'insecure']
end
