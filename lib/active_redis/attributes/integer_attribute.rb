module ActiveRedis
  module Attributes
    class IntegerAttribute < Attribute

      def self.load(value)
        value.nil? || value.empty? ? nil : value.to_i
      end

      def self.dump(value)
        value ? value.to_s : nil
      end

    end
  end
end