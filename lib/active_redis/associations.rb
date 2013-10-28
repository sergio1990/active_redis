module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def has_one(name)
        define_attributes_accessors "#{name.to_s}_id"
        define_method name.to_s do
          name.to_s.capitalize.constantize.find(self.send("#{name.to_s}_id"))
        end
        define_method "#{name.to_s}=" do |value|
          self.send "#{name.to_s}_id=", value.id
        end
      end

      # TODO: add has_many functionality
      def has_many

      end

      # TODO: add belongs_to functionality
      def belongs_to

      end

    end
  end
end