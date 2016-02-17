include_recipe 'ecology-cluster::default'
node['slurm']['packages']['build'].each do |pkg|
  package pkg
end
directory '/var/www/html/slurm-rpms' do
  owner 'httpd'
  group 'httpd'
end
slurm_build 'slurm' do
  rpmbuildopts node['slurm']['rpmbuildopts']
  version node['slurm']['version']
  url node['slurm']['source_url']
  output_rpms '/var/www/html/slurm-rpms'
end
include_recipe 'apache2'

