module Enlace
  module Fiscal
    class Line < Entity
      def_attributes :quantity, :unit, :sku, :description,
        :unit_price, :total

      UNITS = [:piece, :na]

      def valid?
        @errors = {}

        validate_required *(attributes - [:sku])
        validate_equal_or_less_than_zero :quantity, :unit_price
        validate_option UNITS, :unit

        super
      end
    end
  end
end
