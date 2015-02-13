module Enlace
  module Fiscal
    class Payment < Entity
      using Enlace::Fiscal::Blank

      def_attributes :payment_method, :account_number, :details
      DETAILS_TEXT = 'Pago en una sóla exhibición'
      PAYMENT_METHODS = [:credit, :debit, :electronic_transfer, :cash, :check, :unknown]

      def initialize
        super

        self.payment_method = :credit
        self.details = DETAILS_TEXT
      end

      def valid?
        validate_required *(attributes - [:account_number])
        validate_option PAYMENT_METHODS, :payment_method

        add_error(:account_number, "can't be blank") if account_number_required?

        super
      end

      private
      def account_number_required?
        required = (PAYMENT_METHODS - [:cash]).include?(self.payment_method)
        return true if self.account_number.blank? && required
        false
      end
    end
  end
end
