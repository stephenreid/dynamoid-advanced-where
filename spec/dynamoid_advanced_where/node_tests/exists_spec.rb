require 'spec_helper'

RSpec.describe "Attribute Existance" do
  let(:klass) do
    new_class(table_name: 'attr_exist', table_opts: {key: :bar} ) do
      field :simple_string
    end
  end

  describe "attribute existance" do
    let(:klass2) do
      new_class(table_opts: {key: :bar} )
    end

    it "only returns exact matches" do
      item1 = klass.create(simple_string: 'foo')
      klass.create(simple_string: nil)
      klass2.create

      expect(
        klass.where{ simple_string }.all
      ).to match_array [item1]
    end

    it "allows negation" do
      klass.create(simple_string: 'foo')
      item1 = klass.create(simple_string: nil)
      item2 = klass2.create

      expect(
        klass.where{ !simple_string }.all
      ).to match_array [item1, item2]
    end
  end

end
