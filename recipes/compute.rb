include_recipe 'ecology-cluster::default'

if Chef::Config[:solo]
  head = node
else
  heads = search(:node,
                 "role:cluster-#{node['ecology-cluster']['cluster']} AND "\
                 'recipes:ecology-cluster\:\:head',
                 filter_result: { name: ['hostname'],
                                  ip: ['ipaddress']
                                }
                )
  print heads
  head = heads[0]
end

include_recipe 'nfs::client4'

mount '/home' do
  device "#{head['name']}:/home"
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end
