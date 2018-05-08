require 'spec_helper'

RSpec.describe "Greater Than" do
  let(:klass) do
    new_class(table_name: 'greater_than_test', table_opts: {key: :bar} ) do
      field :simple_string
      field :num, :number
    end
  end

  describe "of a string field" do
    let!(:item1) { klass.create(simple_string: 'foo') }

    it "raises an error" do
      expect{
        klass.where{ simple_string > 5}.all
      }.to raise_error(
        ArgumentError,
        'Unable to perform greater than on field of type string'
      )
    end
  end

  describe "of a number field" do
    it "raises an error if the value is not a numeric" do
      expect{
        klass.where{ num > '5'}.all
      }.to raise_error(
        ArgumentError,
        'Unable to perform greater than on value of type String'
      )
    end

    it "only returns items matching the conditions" do
      klass.create(num: 2)
      item1 = klass.create(num: 5)
      expect(klass.where{ num > 4}.all).to eq [item1]
    end
  end
end
