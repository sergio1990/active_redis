module ActiveRedis
  module Associations

    class HasManyAssociation < Association

      def read(object)
        @name.to_s.singularize.capitalize.constantize.where("#{@target.foreign_key_name}" => object.id)
      end

      def write(object, value)
        value.each do |assoc_object|
          assoc_object.send "#{@target.foreign_key_name}=", object.id
        end
      end

      def save(object)
        value = object.send :instance_variable_get, "@assoc_#{@name}"
        return unless value
        write object, value
        value.each { |v| v.save }
      end

    end

  end
end