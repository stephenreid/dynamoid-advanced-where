require 'spec_helper'


RSpec.describe 'Integration with model where' do
  let(:klass) do
    new_class
  end

  it "throws an error if you pass a block and parameters" do
    expect {
      klass.where(foo: 123){ 1 }
    }.to raise_error ArgumentError, "You may not specify where arguments and block"
  end
end
