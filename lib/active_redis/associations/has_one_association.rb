module ActiveRedis
  module Associations

    class HasOneAssociation < Association

      def read(object)
        @name.to_s.capitalize.constantize.where("#{@target.foreign_key_name}" => object.id).top
      end

      def write(object, value)
        value.send "#{@target.foreign_key_name}=", object.id
      end

      def save(object)
        value = object.send :instance_variable_get, "@assoc_#{@name}"
        return unless value
        write object, value
        value.save
      end

    end

  end
end