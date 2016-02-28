include_recipe 'ecology-cluster::default'
node['slurm']['packages']['build'].each do |pkg|
  package pkg
end
include_recipe 'apache2'
web_app 'slurm_rpms' do
  server_name node['hostname']
  server_aliases [node['fqdn']]
  docroot node['slurm']['outputdir']
  cookbook 'apache2'
end
directory '/var/www/html/slurm-rpms' do
  owner 'apache'
  group 'apache'
end
package 'createrepo'
slurm_version = node['slurm']['version']
slurm_checksum = node['slurm']['checksum']
slurm_outputdir = node['slurm']['outputdir']
slurm_target = "#{Chef::Config['file_cache_path']}/"\
               "slurm-#{slurm_version}.tar.bz2"
if File.exist?('/vagrant/slurm.tar.bz2')
  slurm_source = 'file:///vagrant/slurm.tar.bz2'
else
  slurm_source = 'http://www.schedmd.com/download/latest'\
                 "/slurm-#{slurm_version}.tar.bz2"
end
remote_file slurm_target do
  source slurm_source
  checksum slurm_checksum
  notifies :run, 'execute[build-slurm]', :immediately
end
execute 'build-slurm' do
  command "rpmbuild --define '_rpmdir #{slurm_outputdir}' "\
          "#{node['slurm']['rpmbuildopts']} "\
          "-ta #{Chef::Config['file_cache_path']}/"\
          "slurm-#{slurm_version}.tar.bz2"
  notifies :run, 'execute[createrepo]', :immediately
  notifies :restart, 'service[apache2]', :immediately
  action :nothing
end
execute 'createrepo' do
  command "createrepo #{slurm_outputdir}"
  notifies :run, 'execute[chown-apache]'
  action :nothing
end
execute 'chown-apache' do
  command "chown -R apache:apache #{slurm_outputdir}"
end

yum_repository 'local-slurm' do
  description 'Local Slurm Repository'
  baseurl "http://#{node['hostname']}"
  gpgcheck false
  enabled true
  priority '99'
  action :create
end

include_recipe 'slurm::slurm'

include_recipe 'nfs::server'

nfs_export '/home' do
  network '*'
  writeable true
  sync true
  options ['no_root_squash']
end
