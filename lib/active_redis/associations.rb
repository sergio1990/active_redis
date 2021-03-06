Dir[File.dirname(__FILE__) + '/associations/*.rb'].each {|file| require file }
require 'active_redis/constants'
require 'active_redis/errors'

module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
      class << base; attr_accessor :associations; end
      base.send :alias_method_chain, :save, :associations
    end

    def save_with_associations
      self.class.associations.each { |key, a| a.save(self) } if self.class.associations
      save_without_associations
    end

    module ClassMethods

      ActiveRedis::Constants::ASSOCIATIONS.each do |assoc|
        class_eval <<-CODE
          def #{assoc.to_s}(name, options = {})
            register_association name, :#{assoc.to_s}, options
          end
        CODE
      end

      def association(name)
        raise UnregisteredAssociationError, "Unknown association :#{name}!" unless self.associations.has_key? name.to_sym
        self.associations[name.to_sym]
      end

      private

      def register_association(name, type, options)
        self.associations ||= {}
        self.associations[name.to_sym] = "ActiveRedis::Associations::#{type.to_s.classify}Association".constantize.new(name, self, options)
      end

    end
  end
end