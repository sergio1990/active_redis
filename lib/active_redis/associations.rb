Dir[File.dirname(__FILE__) + '/associations/*.rb'].each {|file| require file }

module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
      class << base; attr_accessor :associations; end
    end

    module ClassMethods

      ActiveRedis::Constants::ASSOCIATIONS.each do |assoc|
        class_eval <<-CODE
          def #{assoc.to_s}(name)
            register_association name, :#{assoc.to_s}
          end
        CODE
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