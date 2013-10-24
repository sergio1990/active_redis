module ActiveRedis
  module Attributes

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def attributes(*attrs)
        attrs = attrs.concat([:id, :created_at])
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