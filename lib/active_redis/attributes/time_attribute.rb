module ActiveRedis
  module Attributes
    class TimeAttribute < Attribute

      def self.load(value)
        value.nil? || value.empty? ? nil : Time.at(value.to_i)
      end

      def self.dump(value)
        value ? value.to_i.to_s : nil
      end

    end
  end
end