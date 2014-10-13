require 'spec_helper'
describe 'mco_user' do

  context 'with defaults for all parameters' do
    it { should contain_class('mco_user') }
  end
end
