module ActiveRedis
  module Associations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # TODO: add has_one functionality
      def has_one(name)

      end

      # TODO: add has_many functionality
      def has_many

      end

      # TODO: add belongs_to functionality
      def belongs_to

      end

    end
  end
end