require 'spec_helper'

describe command('scl enable ruby193 -- gem list') do
  its(:stdout) { should contain('fast_github') }
end
