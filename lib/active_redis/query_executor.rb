module ActiveRedis
  class QueryExecutor

    def self.execute(target, where, order, limit)
      ActiveRedis.connection.run_query_analyzer target, [prepare_where(where), prepare_order(order), prepare_limit(limit)]
    end

    private

    def self.prepare_where(where)
      where.keys.map{|key| "#{key}=#{where[key]}" }.join(",")
    end

    def self.prepare_order(order)
      field = order.keys.first
      "#{field}=#{order[field]}"
    end

    def self.prepare_limit(limit)
      limit.any? ? "#{limit[:page]}=#{limit[:per_page]}" : ""
    end

  end
end