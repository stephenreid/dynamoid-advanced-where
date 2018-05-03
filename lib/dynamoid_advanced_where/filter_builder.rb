module DynamoidAdvancedWhere
  class FilterBuilder
    attr_accessor :query_builder, :hash_key_node, :range_key_node

    delegate :root_node, to: :query_builder
    delegate :all_nodes, to: :root_node

    def initialize(query_builder:, hash_key_node:, range_key_node: )
      self.query_builder = query_builder
      self.hash_key_node = hash_key_node
      self.range_key_node = range_key_node
    end

    def index_nodes
      [
        hash_key_node,
        range_key_node
      ]
    end

    def to_filter_hash(filter_key: )
      {
        expression_attribute_names: (all_nodes + index_nodes).compact.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_names)
        end,
        expression_attribute_values: (all_nodes + index_nodes).compact.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_values)
        end,
      }.merge(
        filter_key => root_node.to_condition_expression,
      ).delete_if{|_, v| v.nil? || v.empty? }
    end
  end
end
