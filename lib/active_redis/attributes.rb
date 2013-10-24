module ActiveRedis
  module Attributes

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def attributes(*attrs)
        attrs.concat([:id, :created_at]).each do |attribute|
          define_method "#{attribute}=" do |value|
            instance_variable_set("@#{attribute}", value)
          end
          define_method attribute do
            instance_variable_get("@#{attribute}")
          end
        end
      end

    end

  end
end