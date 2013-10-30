module ActiveRedis
  module Associations

    class HasOneAssociation < Association

      def read(object)
        @name.to_s.capitalize.constantize.where("#{@target.foreign_key_name}" => object.id).first
      end

      def write(object, value)
        value.send "#{@target.foreign_key_name}=", object.id
      end

    end

  end
end