require_relative './filter_builder'

module DynamoidAdvancedWhere
  class QueryMaterializer
    include Enumerable
    attr_accessor :query_builder

    delegate :klass, to: :query_builder
    delegate :table_name, to: :klass
    delegate :to_a, :first, to: :each

    def initialize(query_builder:)
      self.query_builder = query_builder
    end

    def must_scan?
      !self.query_builder
        .root_node
        .all_nodes
        .lazy
        .detect do |node|
          node.respond_to?(:term) &&
            node.term.to_s == query_builder.klass.hash_key.to_s
        end
    end

    def all
      each.to_a
    end

    def each(&blk)
      return enum_for(:each) unless blk

      if must_scan?
        each_via_scan(&blk)
      end
    end

    def each_via_scan
      query = {
        table_name: table_name
      }.merge(filter_clauses)

      if query.has_key?(:condition_expression)
        query[:filter_expression] = query.delete(:condition_expression)
      end

      results = client.scan(query)

      results.items.each do |item|
        yield klass.from_database(item.symbolize_keys)
      end
    end

    def filter_clauses
      FilterBuilder.new(query_builder: self.query_builder).to_filter_hash
    end

    private
    def client
      Dynamoid.adapter.client
    end
  end
end
