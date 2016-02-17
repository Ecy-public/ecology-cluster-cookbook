#
# Cookbook Name:: ecology-cluster
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

search(:node, '*:*',
       filter_result: { name: ['name'],
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

