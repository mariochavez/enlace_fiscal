module Enlace
  module Fiscal
    class Tax < Entity
      def_attributes :type, :rate, :total, :kind

      TAXES = [:iva, :isr]
      KINDS = [:retained, :translated]

      def valid?
        @errors = {}

        validate_required *attributes

        validate_less_than_zero :total, :rate
        validate_option TAXES, :type
        validate_option KINDS, :kind
        super
      end
    end
  end
end
