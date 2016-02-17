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
  hostsfile_entry result['ipaddress'] do
    hostname result['name']
  end
end

hostsfile_entry '192.168.33.254' do
  hostname 'mgmt'
end
