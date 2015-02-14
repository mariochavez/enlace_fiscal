module Enlace
  module Fiscal
    class Invoice < Entity

      DECIMALS = 2
      CURRENCY = 'MNX'

      def_attributes :serie, :folio, :date, :subtotal, :total, :rfc

      has_one :payment, :receptor
      has_many :lines

      def initialize
        super
        @lines = [Line.new]
      end

      def add_line
        @lines << Line.new
      end

      def delete_at(index)
        @lines.delete_at index
      end

      def valid?
        validate_required *attributes
        validate_less_than_zero :subtotal, :total
        validate_rfc_format :rfc
        validate_rfc_length :rfc

        super
      end
    end
  end
end
