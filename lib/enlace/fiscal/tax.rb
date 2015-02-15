module Enlace
  module Fiscal
    class Tax < Entity
      def_attributes :type, :rate, :total, :kind

      TAXES = [:iva, :isr]
      KINDS = [:retained, :translated]

      def initialize
        super

        self.type = :iva
        self.kind = :retained
      end

      def valid?
        @errors = {}

        validate_required *attributes

        validate_less_than_zero :total, :rate
        validate_option TAXES, :type
        validate_option KINDS, :kind
        super
      end

      def to_h
        {
          'impuesto' => type.to_s.upcase,
          'tasa' => format_decimal(rate),
          'importe' => format_decimal(total)
        }
      end
    end
  end
end
