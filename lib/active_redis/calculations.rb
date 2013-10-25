module ActiveRedis
  module Calculations

    def count
      ActiveRedis.connection.count_key table_name
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

  end
end