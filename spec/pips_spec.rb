require 'spec_helper'

describe command('scl enable python33 -- pip list') do
  its(:stdout) { should contain('snakeoil') }
end
