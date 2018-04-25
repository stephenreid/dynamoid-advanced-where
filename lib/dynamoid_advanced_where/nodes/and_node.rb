module DynamoidAdvancedWhere
  module Nodes
    class AndNode < BaseNode
      attr_accessor :child_nodes

      def to_condition_expression
        "#{@negated ? 'NOT ' : ''}(#{child_nodes.map(&:to_condition_expression).join(') and (')})"
      end

      def negate!
        @negated = !@negated
      end
    end
  end
end
