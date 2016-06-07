#
# Cookbook Name:: ecology-cluster
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'omnibus_updater'
include_recipe 'chef-client::config'
include_recipe 'chef-client'

unless Chef::Config[:solo]
  search(:node, '*:*',
         filter_result: { name: ['name'],
                          ip: ['network', 'interfaces', node['ecology-cluster']['interface'], 'addresses']
                        }
        ).each do |result|
    ipv4_address = nil
    puts result
    next unless result['ip']
    result['ip'].each_key do |key|
      if result['ip'][key]['family'].eql?('inet')
        ipv4_address = key
      end
    end
    puts 
    next unless ipv4_address && result['name']
    hostsfile_entry ipv4_address do
      hostname result['name']
    end
  end
end

hostsfile_entry '127.0.0.1' do
  hostname 'localhost localhost.localdomain localhost4 localhost4.localdomain4'
end

hostsfile_entry '::1' do
  hostname 'localhost localhost.localdomain localhost6 localhost6.localdomain6'
end

include_recipe 'yum-centos'
include_recipe 'yum-epel'
include_recipe 'build-essential'
package 'bzip2'
package 'vim'
package 'screen'
package 'lua'
package 'tcsh'
package 'lua-filesystem'
package 'lua-posix'
package 'lua-devel'
package 'pkgconfig'
package 'fail2ban-firewalld'
package 'fail2ban-systemd'

service 'firewalld' do
  action [:enable, :start]
end

cookbook_file 'fail2ban_customizations' do
  source 'fail2ban_customizations.conf'
  path '/etc/fail2ban/jail.d/customization.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'fail2ban' do
  action [:enable, :start]
end

%w(
172.31.16.0/20
172.31.32.0/20
172.31.0.0/20
).each do |network|
  execute "firewall-cmd --zone=trusted --add-source #{network}" do
    not_if "firewall-cmd --zone trusted --list-sources | grep -q #{network}"
  end
end
