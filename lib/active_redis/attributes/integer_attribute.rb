module ActiveRedis
  module Attributes
    class IntegerAttribute < Attribute

      def self.load(value)
        value.to_i
      end

      def self.dump(value)
        value.to_s
      end

    end
  end
end