module ActiveRedis
  module Finders

    def find(*ids)
      ids.map { |id| self.new(ActiveRedis.connection.fetch_row(self, id)) }
    end

    def where(params)
      ActiveRedis.connection.fetch_where(self, params).map { |attrs| self.new(attrs) }
    end

    def all
      ActiveRedis.connection.fetch_all(self).map { |attrs| self.new(attrs) }
    end

  end
end