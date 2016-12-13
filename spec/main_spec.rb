require 'spec_helper'

describe file('/usr/local/bin/scl-shebang') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end
