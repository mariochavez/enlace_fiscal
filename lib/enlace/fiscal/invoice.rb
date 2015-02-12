module Enlace
  module Fiscal
    class Invoice < Entity
      using Enlace::Fiscal::Blank

      DECIMALS = 2
      CURRENCY = 'MNX'

      def_attributes :serie, :folio, :date, :subtotal, :total, :rfc

      has_one :payment

      def valid?
        attributes.each do |attr|
          value = send(attr)
          add_error(attr, "can't be blank") if value.blank?
        end

        add_error(:subtotal, "can't be less than zero") if less_than_zero?(:subtotal)
        add_error(:total, "can't be less than zero") if less_than_zero?(:total)
        add_error(:rfc, 'has invalid format') if invalid_rfc_format?
        add_error(:rfc, 'has invalid length') if invalid_rfc_length?

        errors.empty?
      end

      private
      def invalid_rfc_length?
        value = self.rfc || ''
        !value.length.between?(12,13)
      end

      def invalid_rfc_format?
        match = self.rfc =~ /[a-z,A-Z,Ñ,&amp;]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,a-z,0-9]?[A-Z,a-z,0-9]?[0-9,a-z,A-Z]?/
        match.nil?
      end

      def less_than_zero?(attr)
        value = send(attr) || 0
        value < 0
      end
    end
  end
end
