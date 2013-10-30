module ActiveRedis
  module Associations

    class Association

      def initialize(name, target)
        @name, @target = name, target
        define_read_association
        define_write_association
      end

      private

      def define_read_association
        @target.class_eval <<-CODE
          def #{@name}
            self.class.association(:#{@name}).read(self)
          end
        CODE
      end

      def define_write_association
        @target.class_eval <<-CODE
          def #{@name}=(value)
            self.class.association(:#{@name}).write(self, value)
          end
        CODE
      end
    end

  end
end