require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain '192.168.123.123	default-centos-72' }
end

describe file('/etc/hosts') do
  it { should contain '192.168.123.10	head-centos-72' }
end

describe file('/etc/hosts') do
  it { should contain '192.168.123.11	compute-centos-72' }
end
