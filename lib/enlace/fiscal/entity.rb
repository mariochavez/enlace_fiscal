module Enlace
  module Fiscal
    class Entity
      def initialize
        @errors = {}
      end

      def attributes
        self.class.attributes ||= {}
      end

      def valid?
        true
      end

      def errors
        @errors
      end

      def add_error(attribute, message)
        @errors[attribute] ||= []
        @errors[attribute] << message
        attribute
      end

      class << self
        attr_reader :attributes

        def def_attributes(*list)
          self.class_eval do
            attr_accessor *list
          end

          @attributes = list
        end

        def has_one(*list)
          list.each do |relation|
            define_method(relation.to_s) {
              ivar = instance_variable_get("@#{relation.to_s}")
              if ivar.nil?
                ivar = Object.const_get("Enlace::Fiscal::#{relation.capitalize}").new
                instance_variable_set("@#{relation.to_s}", ivar)
              end

              ivar
            }
          end
        end
      end

    end
  end
end
