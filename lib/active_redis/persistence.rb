module ActiveRedis
  module Persistence

    def self.included(base)
      base.extend ClassMethods
    end

    def save
      attrs = prepare_hash
      ActiveRedis.connection.save_table self.class.table_name(attrs[:id]), attrs.flatten
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

      def create(*attrs)

      end

    end

  end
end