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

      def valid_all?
        valid?

        relations.each do |relation|
          name = relation.to_s
          value = send(relation)

          if value.is_a?(Array)
            value.each_with_index do |val, index|
              add_relation_errors name, val, index
            end
          else
            add_relation_errors name, value
          end
        end

        @errors.empty?
      end

      def to_h
        {
          'modo' => EF.mode,
          'versionEF' => EF.version,
          'serie' => serie,
          'folioInterno' => folio,
          'fechaEmision' => format_date(DateTime.now),
          'subTotal' => format_decimal(subtotal),
          'descuentos' => format_decimal(0),
          'total' => format_decimal(total),
          'numeroDecimales' => DECIMALS,
          'tipoMoneda' => CURRENCY,
          'rfc' => rfc,
          'DatosDePago' => payment.to_h,
          'Receptor' => receptor.to_h,
          'Partidas' => {
            'Partida' => lines.map{|line| line.to_h}
          },
          'Impuestos' => {
            'totalImpuestosRetenidos' => format_decimal(tax_retained_total),
            'totalImpuestosTrasladados' => format_decimal(tax_translated_total),
            'Retenciones' => {
              'Retencion' => []
            },
            'Traslados' => {
              'Traslado' => []
            }
          }
        }
      end

      private
      def add_relation_errors(relation_name, value, index = nil)
        value.valid?

        value.errors.each_pair do |attr, error|
          attr_error_name = if index.nil?
                              "#{relation_name}_#{attr.to_s}".to_sym
                            else
                              "#{relation_name}_#{index}_#{attr.to_s}".to_sym
                            end

          add_error(attr_error_name, error.first)
        end
      end
    end
  end
end
