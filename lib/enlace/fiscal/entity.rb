module Enlace
  module Fiscal
    class Entity
      using Enlace::Fiscal::Blank

      def initialize
        @errors = {}
      end

      def attributes
        self.class.attributes ||= {}
      end

      def valid?
        errors.empty?
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

        def has_many(*list)
          list.each do |relation|
            define_method(relation.to_s) {
              ivar = instance_variable_get("@#{relation.to_s}")
              if ivar.nil?
                ivar = [Object.const_get("Enlace::Fiscal::#{singularize(relation.to_s).capitalize}").new]
                instance_variable_set("@#{relation.to_s}", ivar)
              end

              ivar
            }
          end
        end
      end

      protected
      def singularize(text)
        new_text = text.gsub(/ies$/, 'y')
        new_text = new_text.gsub(/xes$/, 'x')
        new_text.gsub(/s$/, '')
      end

      def validate_option(options, attribute)
        value = send(attribute)
        add_error(attribute, 'invalid option') if !options.include?(value)
      end

      def validate_required(*list)
        list.each do |attribute|
          value = send(attribute)
          add_error(attribute, "can't be blank") if value.blank?
        end
      end

      def validate_less_than_zero(*list)
        list.each do |attribute|
          value = send(attribute).to_i
          add_error(attribute, "can't be less than zero") if value < 0
        end
      end

      def validate_equal_or_less_than_zero(*list)
        list.each do |attribute|
          value = send(attribute).to_i
          add_error(attribute, 'must be greater than zero') if value <= 0
        end
      end

      def validate_rfc_format(*list)
        list.each do |attribute|
          value = send(attribute) || ''
          match = value =~ /[a-z,A-Z,Ñ,&amp;]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,a-z,0-9]?[A-Z,a-z,0-9]?[0-9,a-z,A-Z]?/

          add_error(attribute, 'has invalid format') if match.nil?
        end
      end

      def validate_rfc_length(*list)
        list.each do |attribute|
          value = send(attribute) || ''

          add_error(attribute, 'has invalid length') if !value.length.between?(12, 13)
        end
      end
    end
  end
end
