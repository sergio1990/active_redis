Dir[File.dirname(__FILE__) + '/attributes/*.rb'].each {|file| require file }

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
      self.class.attributes_list.inject({}) do |hash, attribute|
        hash[attribute.to_sym] = self.send(attribute.to_s)
        hash
      end
    end

    module ClassMethods

      def attributes(attrs)
        raise ActiveRedis::InvalidArgumentError, "Value must be a Hash!" unless attrs.is_a?(Hash)
        attrs = attrs.merge(ActiveRedis::Constants::DEFAULT_ATTRIBUTES)
        class << self; attr_accessor :defined_attributes; end
        self.defined_attributes ||= {}
        define_attributes_accessors attrs
      end

      def define_attributes_accessors(attrs)
        attrs.each do |attribute, type|
          next unless register_attribute(attribute, type)
          read_attribute attribute
          write_attribute attribute
        end
      end

      def attributes_list
        self.defined_attributes.keys.map(&:to_s)
      end

      private

      def register_attribute(attribute, type)
        return if self.defined_attributes.has_key? attribute.to_sym
        self.defined_attributes[attribute.to_sym] = {
          class: "ActiveRedis::Attributes::#{type.to_s.capitalize}Attribute".constantize,
          type: type
        }
      end

      def attribute_class(attribute)
        attr_class = self.defined_attributes[attribute.to_sym][:class]
      end

      def read_attribute(attribute)
        define_method attribute do
          klass = self.class.send :attribute_class, attribute
          klass.load(instance_variable_get("@#{attribute}"))
        end
      end

      def write_attribute(attribute)
        define_method "#{attribute}=" do |value|
          klass = self.class.send :attribute_class, attribute
          klass.dump(instance_variable_set("@#{attribute}", value))
        end
      end

    end

  end
end