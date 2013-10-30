Dir[File.dirname(__FILE__) + '/associations/*.rb'].each {|file| require file }

module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
      class << base; attr_accessor :associations; end
    end

    module ClassMethods

      def has_one(name)
        register_association name, :has_one
      end

      def has_many(name)
        define_method name.to_s do
          name.to_s.singularize.capitalize.constantize.where("#{self.class.foreign_key_name}" => self.id)
        end
        define_method "#{name.to_s}=" do |value|
          value.each do |object|
            object.send "#{self.class.foreign_key_name}=", self.id
          end
        end
      end

      def belongs_to(name)
        define_attributes_accessors "#{name.to_s}_id" => :integer
        define_method name.to_s do
          name.to_s.capitalize.constantize.find(self.send("#{name.to_s}_id"))
        end
        define_method "#{name.to_s}=" do |value|
          self.send "#{name.to_s}_id=", value.id
        end
      end

      def association(name)
        raise UnregisteredAssociationError, "Unknown association :#{name}!" unless self.associations.has_key? name.to_sym
        self.associations[name.to_sym]
      end

      private

      def register_association(name, type)
        self.associations ||= {}
        self.associations[name.to_sym] = "ActiveRedis::Associations::#{type.to_s.classify}Association".constantize.new(name, self)
      end

    end
  end
end