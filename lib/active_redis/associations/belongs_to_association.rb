module ActiveRedis
  module Associations

    class BelongsToAssociation < Association

      def initialize(name, target)
        super(name, target)
        target.define_attributes_accessors("#{@name.to_s}_id" => :integer)
      end

      def read(object)
        @name.to_s.capitalize.constantize.find(object.send("#{@name.to_s}_id"))
      end

      def write(object, value)
        object.send "#{@name.to_s}_id=", value.id
      end

    end

  end
end