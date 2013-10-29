module ActiveRedis
  module Attributes
    class TimeAttribute < Attribute

      def self.load(value)
        Time.at(value.to_i)
      end

      def self.dump(value)
        Time.to_i.to_s
      end

    end
  end
end