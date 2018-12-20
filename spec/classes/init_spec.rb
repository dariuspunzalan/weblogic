require 'spec_helper'
describe 'bcc' do
  context 'with default values for all parameters' do
    it { should contain_class('bcc') }
  end
end
