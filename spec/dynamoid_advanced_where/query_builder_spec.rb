require 'spec_helper'

RSpec.describe 'QueryBuilder' do
  describe "when searching unknown methods" do
    let(:klass) do
      new_class do
        field :foo
      end
    end

    it "errors when a unset field is passed" do
      expect {
        klass.where{ bar == 1 }
      }.to raise_error NameError, /bar/
    end

    it "generates a query builder when using a valid field" do
      expect {
        klass.where{ foo == 1 }
      }.not_to raise_error
    end
  end
end
