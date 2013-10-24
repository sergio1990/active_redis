module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def has_one

      end

      def has_many

      end

      def belongs_to

      end

    end
  end
end