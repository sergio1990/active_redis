module ActiveRedis
  module Persistence

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize(attrs = {})
      attrs.each { |attribute, value| self.send("#{attribute}=", value) }
    end

    def save
      ActiveRedis.connection.save_table self.class, prepare_hash
    end

    def destroy
      ActiveRedis.connection.destroy self.class, self.id
    end

    private

      def prepare_hash
        self.class.defined_attributes.inject({}) do |hash, attribute|
          hash[attribute] = self.send("#{attribute}")
          hash
        end.tap do |hash|
          hash[:id] ||= ActiveRedis.connection.next_id(self.class)
          hash[:created_at] ||= Time.now.to_i
          hash[:updated_at] = Time.now.to_i
        end
      end

    module ClassMethods

      def create(attrs = {})
        self.class.new(attrs).tap do |model|
          model.save
        end
      end

      def destroy_all
        ActiveRedis.connection.destroy_all self
      end

      # TODO: add functionality for update_attribute and update_attributes methods like ActiveRecord

    end

  end
end