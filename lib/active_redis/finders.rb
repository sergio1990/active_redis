module ActiveRedis
  module Finders

    def find(*ids)
      ids.map { |id| self.new(ActiveRedis.connection.fetch_row(self, id)) }
    end

    def pluck(attribute)
      ActiveRedis.connection.fetch_all_with_attribute(self, attribute)
    end

  end
end