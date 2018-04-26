module DynamoidAdvancedWhere
  class FilterBuilder
    attr_accessor :query_builder, :primary_key_node

    delegate :root_node, to: :query_builder
    delegate :all_nodes, to: :root_node

    def initialize(primary_key_node:, query_builder: )
      self.query_builder = query_builder
      self.primary_key_node = primary_key_node
    end

    def to_filter_hash(filter_key: )
      {
        expression_attribute_names: (all_nodes + [primary_key_node]).compact.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_names)
        end,
        expression_attribute_values: (all_nodes + [primary_key_node]).compact.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_values)
        end,
      }.merge(
        filter_key => root_node.to_condition_expression,
      ).delete_if{|_, v| v.nil? || v.empty? }
    end
  end
end
