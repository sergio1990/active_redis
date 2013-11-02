module ActiveRedis
  module Associations

    class Association

      def initialize(name, target)
        @name, @target = name, target
        define_read_association
        define_write_association
      end

      def reload(object)
        object.send :instance_variable_set, "@assoc_#{@name}", nil
      end

      private

      def define_read_association
        @target.class_eval <<-CODE
          def #{@name}
            @assoc_#{@name} ||= self.class.association(:#{@name}).read(self)
          end
        CODE
      end

      def define_write_association
        @target.class_eval <<-CODE
          def #{@name}=(value)
            @assoc_#{@name} = value
          end
        CODE
      end
    end

  end
end