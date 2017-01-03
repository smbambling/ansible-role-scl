require 'spec_helper'

describe file('/usr/local/bin/scl-wrapper-ruby193') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end

describe file('/usr/local/bin/scl-shebang-ruby193-ruby') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end

describe file('/usr/local/bin/scl-wrapper-python33') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end

describe file('/usr/local/bin/scl-shebang-python33-python') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end
