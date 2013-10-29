module ActiveRedis
  module Attributes
    class StringAttribute < Attribute

      def self.load(value)
        value.to_s
      end

      def self.dump(value)
        value.to_s
      end

    end
  end
end