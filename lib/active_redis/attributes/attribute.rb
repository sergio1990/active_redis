module ActiveRedis
  module Attributes

    class Attribute

      def self.load(value)
        raise NotImplementedError
      end

      def self.dump(value)
        raise NotImplementedError
      end

    end

  end
end