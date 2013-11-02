module ActiveRedis
  module Persistence

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def save
      ActiveRedis.connection.save_table self.class, prepare_hash
    end

    def destroy
      ActiveRedis.connection.destroy self.class, self.id
    end

    def update(attrs = {})
      self.attributes = attrs
      self.save
    end

    def reload
      if self.class.respond_to? :associations
        self.class.associations.each { |key, assoc| assoc.reload(self) }
      end
      true
    end

    def touch
      save
    end

    private

      def fill_attributes
        self.id         ||= ActiveRedis.connection.next_id(self.class)
        self.created_at ||= Time.now
        self.updated_at   = Time.now
      end

      def prepare_hash
        fill_attributes
        self.class.attributes_list.inject({}) do |hash, attribute|
          hash[attribute.to_sym] = self.instance_variable_get("@#{attribute}"); hash
        end
      end

    module ClassMethods

      def create(attrs = {})
        self.new(attrs).tap do |model|
          model.save
        end
      end

      def destroy_all
        ActiveRedis.connection.destroy_all self
      end

    end

  end
end