module Enlace
  module Fiscal
    class Invoice < Entity

      DECIMALS = 2
      CURRENCY = 'MNX'

      def_attributes :serie, :folio, :date, :subtotal, :total, :rfc,
        :tax_retained_total, :tax_translated_total

      has_one :payment, :receptor
      has_many :lines, :taxes

      def initialize
        super
        @lines = [Line.new]
        @taxes = [Tax.new]
      end

      def add_line
        @lines << Line.new
      end

      def add_tax
        @taxes << Tax.new
      end

      def delete_line_at(index)
        @lines.delete_at index
      end

      def delete_tax_at(index)
        @taxes.delete_at index
      end

      def valid?
        @errors = {}

        validate_required *attributes
        validate_less_than_zero :subtotal, :total, :tax_translated_total,
          :tax_retained_total
        validate_rfc_format :rfc
        validate_rfc_length :rfc

        super
      end
    end
  end
end
