module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def has_one(name)
        define_method name.to_s do
          name.to_s.capitalize.constantize.where("#{self.class.foreign_key_name}" => self.id).first
        end
        define_method "#{name.to_s}=" do |value|
          value.send "#{self.class.foreign_key_name}=", self.id
        end
      end

      # TODO: add has_many functionality
      def has_many

      end

      # TODO: add belongs_to functionality
      def belongs_to(name)
        define_attributes_accessors "#{name.to_s}_id"
        define_method name.to_s do
          name.to_s.capitalize.constantize.find(self.send("#{name.to_s}_id"))
        end
        define_method "#{name.to_s}=" do |value|
          self.send "#{name.to_s}_id=", value.id
        end
      end

    end
  end
end