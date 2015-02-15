module Enlace
  module Fiscal
    module Format
      def format_date(date)
        date.strftime('%FT%T')
      end

      def format_decimal(value)
        value ||= 0
        sprintf("%.02f", value)
      end
    end
  end
end
