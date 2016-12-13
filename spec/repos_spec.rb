require 'spec_helper'

describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '644' }
end

describe yumrepo('centos-sclo-sclo') do
  it { should exist }
  it { should be_enabled }
end

describe yumrepo('centos-sclo-rh') do
  it { should exist }
  it { should be_enabled }
end
