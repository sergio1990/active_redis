module ActiveRedis
  module Finders

    def find(*ids)
      ids.map { |id| self.new(ActiveRedis.connection.fetch_row(self, id)) }
    end

    # TODO: Add finders methods like where

  end
end