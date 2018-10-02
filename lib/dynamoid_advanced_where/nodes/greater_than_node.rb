module DynamoidAdvancedWhere
  module Nodes
    class GreaterThanNode < BaseNode
      class << self
        def determine_subtype(attr_config, value)
          case attr_config[:type]
          when :number
            NumberAttr::GreaterThanNode
          when :datetime
            DatetimeAttr::GreaterThanNode
          when :date
            DateAttr::GreaterThanNode
          else
            raise ArgumentError, "Unable to perform greater than on field of type #{attr_config[:type]}"
          end
        end
      end
    end
  end
end
