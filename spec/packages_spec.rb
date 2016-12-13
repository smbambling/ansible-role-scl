require 'spec_helper'

describe package('ruby193') do
  it { should be_installed }
end

describe package('python33') do
  it { should be_installed }
end
