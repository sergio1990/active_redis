module ActiveRedis
  module Calculations

    def count
      ActiveRedis.connection.calculate_count self
    end

    # TODO: add same average, min, max, sum methods

    def max(attribute)
      ActiveRedis.connection.calculate_max self, attribute
    end

    def min(attribute)
      ActiveRedis.connection.calculate_min self, attribute
    end

    def sum(attribute)
      ActiveRedis.connection.calculate_sum self, attribute
    end

    def pluck(attribute)
      ActiveRedis.connection.calculate_pluck self, attribute
    end

  end
end