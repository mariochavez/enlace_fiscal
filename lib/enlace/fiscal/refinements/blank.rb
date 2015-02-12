module Enlace
  module Fiscal
    module Blank
      refine String do
        def blank?
          self.nil? || self.empty?
        end
      end

      refine Fixnum do
        def blank?
          self.nil?
        end
      end

      refine Float do
        def blank?
          self.nil?
        end
      end

      refine Date do
        def blank?
          self.nil?
        end
      end

      refine NilClass do
        def blank?
          true
        end
      end

      refine Symbol do
        def blank?
          self.nil?
        end
      end
    end
  end
end
