require_relative './nodes'
require_relative './query_materializer'

module DynamoidAdvancedWhere
  class QueryBuilder
    attr_accessor :klass, :root_node

    delegate :all, to: :query_materializer

    def initialize(klass:, &blk)
      self.klass = klass
      self.root_node = Nodes::RootNode.new(klass: klass, &blk)
    end

    def query_materializer
      QueryMaterializer.new(query_builder: self)
    end
  end
end
