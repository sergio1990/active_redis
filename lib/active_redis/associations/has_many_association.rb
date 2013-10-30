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

    end

  end
end