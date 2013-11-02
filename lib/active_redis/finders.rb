module ActiveRedis
  module Finders

    def find(*ids)
      res = ids.inject([]) do |result, id|
        attrs = ActiveRedis.connection.fetch_row(self, id)
        result << self.new(attrs) if attrs.any?
        result
      end
      ids.count == 1 ? res.first : res
    end

    def where(params = {})
      ActiveRedis.connection.fetch_where(self, params).map { |attrs| self.new(attrs) }
    end

    def all
      where
    end

  end
end