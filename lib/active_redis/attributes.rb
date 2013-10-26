module ActiveRedis
  module Attributes

    def self.included(base)
      base.extend ClassMethods
    end

    def attributes=(value)
      raise ActiveRedis::InvalidArgumentError, "Value must be a Hash" unless value.is_a? Hash
      value.each { |attribute, value| self.send("#{attribute}=", value) }
    end

    def attributes
      self.class.defined_attributes.inject({}) do |hash, attribute|
        hash[attribute.to_sym] = self.send(attribute.to_s)
        hash
      end
    end

    module ClassMethods

      def attributes(*attrs)
        attrs = attrs.concat(ActiveRedis::Constants::DEFAULT_ATTRIBUTES)
        attrs.each do |attribute|
          define_method "#{attribute}=" do |value|
            instance_variable_set("@#{attribute}", value)
          end
          define_method attribute do
            instance_variable_get("@#{attribute}")
          end
        end
        class << self
          attr_accessor :defined_attributes
        end
        self.defined_attributes = attrs
      end

    end

  end
end