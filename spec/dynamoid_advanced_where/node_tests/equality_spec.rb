require 'spec_helper'

RSpec.describe "Basic value equality matching" do
  let(:klass) do
    new_class(table_name: 'equality_spec', table_opts: {key: :bar} ) do
      field :simple_string
    end
  end

  describe "string equality" do
    let!(:item1) { klass.create(simple_string: 'foo') }
    let!(:item2) { klass.create(simple_string: 'bar') }

    it "matches string equals" do
     expect(
        klass.where{ simple_string == 'foo' }.all
      ).to match_array [item1]
    end

    it "matches string not equals" do
      expect(
        klass.where{ simple_string != 'foo' }.all
      ).to match_array [item2]
    end
  end
end
