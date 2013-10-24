module ActiveRedis
  module Persistence

    def self.included(base)
      base.extend ClassMethods
    end

    def save
      binding.pry
    end

    private

      def prepare_hash
        self.class.defined_attributes.inject({}) do |hash, attribute|
          hash[attribute] = self.send("#{attribute}")
          hash
        end.flatten
      end

    module ClassMethods

      def create

      end

    end

  end
end