module Enlace
  module Fiscal
    class Receptor < Entity
      def_attributes :name, :rfc, :street, :ext_number, :int_number,
        :neighborhood, :locality, :municipality, :state, :country,
        :postal_code

      def initialize
        super

        self.country = 'México'
      end

      def valid?
        @errors = {}

        validate_required :name, :rfc, :street, :state, :country
        validate_rfc_format :rfc
        validate_rfc_length :rfc

        super
      end
    end
  end
end
