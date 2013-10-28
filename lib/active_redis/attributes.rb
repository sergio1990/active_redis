module ActiveRedis
  module Attributes

    def self.included(base)
      base.extend ClassMethods
    end

    def attributes=(value)
      raise ActiveRedis::InvalidArgumentError, "Value must be a Hash or Array" if !value.is_a?(Hash) && !value.is_a?(Array)
      value = Hash[*value] if value.is_a?(Array)
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
        class << self; attr_accessor :defined_attributes; end
        self.defined_attributes ||= []
        define_attributes_accessors attrs
      end

      def define_attributes_accessors(attrs)
        attrs = *attrs unless attrs.is_a?(Array)
        attrs.each do |attribute|
          read_attribute attribute
          write_attribute attribute
          register_attribute attribute
        end
      end

      private

      def register_attribute(attribute)
        self.defined_attributes << attribute unless self.defined_attributes.include?(attribute)
      end

      def read_attribute(attribute)
        define_method attribute do
          instance_variable_get("@#{attribute}")
        end
      end

      def write_attribute(attribute)
        define_method "#{attribute}=" do |value|
          instance_variable_set("@#{attribute}", value)
        end
      end

    end

  end
end