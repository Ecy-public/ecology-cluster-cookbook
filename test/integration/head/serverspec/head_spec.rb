require 'spec_helper'

%w(
  rpcbind
  rpc-statd
  nfs-idmapd
  nfs-server
  slurmd
  slurmctld
).each do |service_name|
  describe service(service_name) do
    it { should be_enabled }
  end
  describe service(service_name) do
    it { should be_running }
  end
end

describe command('sinfo') do
  its(:exit_status) { should eq 0 }
end

describe file('/etc/exports') do
  its(:content) { should contain '/home' }
end
