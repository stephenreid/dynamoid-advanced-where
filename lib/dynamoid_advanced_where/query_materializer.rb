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
      !extract_query_filter_node.is_a?(Nodes::BaseNode)
    end

    def extract_query_filter_node
      @query_filter_node ||=
        case first_node
        when Nodes::TermNode
          if term_node_valid_for_key_filter(first_node)
            self.query_builder.root_node.child_nodes.delete_at(0)
          end
        when Nodes::AndNode
          if first_node.negated? == false
            hash_node_idx = first_node.child_nodes.index(&method(:term_node_valid_for_key_filter))
            first_node.child_nodes.delete_at(hash_node_idx)
          end
        end
    end

    def term_node_valid_for_key_filter(term_node)
      term_node.term.to_s == hash_key
    end

    def all
      each.to_a
    end

    def each(&blk)
      return enum_for(:each) unless blk

      if must_scan?
        each_via_scan(&blk)
      else
        each_via_query(&blk)
      end
    end

    def each_via_query
      query = {
        table_name: table_name
      }.merge(filter_clauses).merge({
        key_condition_expression: extract_query_filter_node.to_condition_expression
      })
      binding.pry

      results = client.query(query)

      if results.items
        results.items.each do |item|
          yield klass.from_database(item.symbolize_keys)
        end
      end
    end

    def each_via_scan
      query = {
        table_name: table_name
      }.merge(filter_clauses)

      results = client.scan(query)

      if results.items
        results.items.each do |item|
          yield klass.from_database(item.symbolize_keys)
        end
      end
    end

    def filter_clauses
      FilterBuilder.new(
        query_builder: self.query_builder,
        primary_key_node: extract_query_filter_node
      ).to_filter_hash(filter_key: :filter_expression)
    end

    private
    def client
      Dynamoid.adapter.client
    end

    def first_node
      self.query_builder.root_node.child_nodes.first
    end

    def hash_key
      @hash_key ||= query_builder.klass.hash_key.to_s
    end
  end
end
