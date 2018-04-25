module DynamoidAdvancedWhere
  class FilterBuilder
    attr_accessor :query_builder

    delegate :root_node, to: :query_builder
    delegate :all_nodes, to: :root_node

    def initialize(query_builder: )
      self.query_builder = query_builder
    end

    def to_filter_hash
      {
        condition_expression: root_node.to_condition_expression,
        expression_attribute_names: all_nodes.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_names)
        end,
        expression_attribute_values: all_nodes.inject({}) do |hsh, i|
          hsh.merge!(i.expression_attribute_values)
        end,
      }.delete_if{|_, v| v.empty? }
    end
  end
end
