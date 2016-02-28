require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain '192.168.33.35    test' }
end

describe file('/etc/hosts') do
  it { should contain '192.168.33.34    compute' }
end

describe file('/etc/munge/munge.key') do
  its(:md5sum) { should eq '355b9ab5bb4c37055a4b246c0c038666' }
end

describe command('echo foo | munge | unmunge -m /dev/null') do
  its(:stdout) { should contain 'foo' }
end
