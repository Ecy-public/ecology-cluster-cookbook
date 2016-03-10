require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain '192.168.33.35	test' }
end

describe file('/etc/hosts') do
  it { should contain '192.168.33.34	compute' }
end
