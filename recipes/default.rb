#
# Cookbook Name:: ecology-cluster
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

search(:node, '*:*',
       filter_result: { name: ['hostname'],
                        ip: ['ipaddress']
                      }
      ).each do |result|
  hostsfile_entry result['ip'] do
    hostname result['name']
  end
end

hostsfile_entry '127.0.0.1' do
  hostname 'localhost localhost.localdomain localhost4 localhost4.localdomain4'
end

hostsfile_entry '::1' do
  hostname 'localhost localhost.localdomain localhost6 localhost6.localdomain6'
end

include_recipe 'slurm::munge'

search(:node, 'role:compute',
       filter_result: { name: ['name'],
                        cpus: %w(cpu total)
                      }
      ).each do |result|
  node['slurm']['slurm']['nodes'].push(
    NodeName: result['name'],
    Procs: result['cpus'],
    State: 'DRAIN'
  )
end

include_recipe 'yum-centos'
include_recipe 'yum-epel'
