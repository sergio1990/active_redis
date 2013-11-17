module ActiveRedis
  class QueryExecutor

    def self.execute(chainer)
      ActiveRedis.connection.run_query_analyzer(chainer.target, [
        prepare_where(chainer.where_options),
        prepare_order(chainer.order_options),
        prepare_limit(chainer.limit_options),
        prepare_aggregation(chainer.aggregation_options)
      ])
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

    def self.prepare_aggregation(aggregation)
      aggregation.inject("") {|str, (k, v)| str = "#{k}=#{v}" }
    end

  end
end