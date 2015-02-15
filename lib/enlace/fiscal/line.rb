module Enlace
  module Fiscal
    class Line < Entity
      def_attributes :quantity, :unit, :sku, :description,
        :unit_price, :total

      UNITS = [:piece, :na]
      UNIT_LOOKUP = { piece: 'pieza', na: 'No aplica' }

      def initialize
        super

        self.unit = :piece
      end

      def valid?
        @errors = {}

        validate_required *(attributes - [:sku])
        validate_equal_or_less_than_zero :quantity, :unit_price
        validate_option UNITS, :unit

        super
      end

      def to_h
        {
          'cantidad' => quantity,
          'unidad' => UNIT_LOOKUP[unit],
          'descripcion' => description,
          'noIdentificacion' => sku,
          'valorUnitario' => format_decimal(unit_price),
          'importe' => format_decimal(total)
        }
      end
    end
  end
end
