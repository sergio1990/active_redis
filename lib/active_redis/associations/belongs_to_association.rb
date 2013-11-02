module ActiveRedis
  module Associations

    class BelongsToAssociation < Association

      DEFAULT_OPTIONS = {touch: false}

      def initialize(name, target, options = {})
        super
        @options ||= DEFAULT_OPTIONS.merge(options)
        target.define_attributes_accessors("#{@name.to_s}_id" => :integer)
      end

      def read(object)
        @name.to_s.capitalize.constantize.find(object.send("#{@name.to_s}_id"))
      end

      def write(object, value)
        object.send "#{@name.to_s}_id=", value.id
      end

      def save(object)
        value = object.send :instance_variable_get, "@assoc_#{@name}"
        return unless value
        write(object, value)
        value.touch if @options[:touch]
      end

    end

  end
end