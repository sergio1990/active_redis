require 'benchmark'

module ActiveRedis::ConnectionExt
  module FindersLayer

    def fetch_row(model, id)
      fetch_where(model, id: id).first
    end

    def fetch_keys(model)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_keys(#{model.name})"
      adapter.keys model.key_name
    end

    def fetch_where(model, params)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_where(#{model.name}, #{params})"
      run_eval :where, [model.key_name], params.flatten
    end

    def run_query_analyzer(model, params = ["", "", ""])
      res = nil
      time = Benchmark.realtime do
        res = run_eval :query_analyzer, [model.key_name, Time.now.to_i], params
      end
      ActiveRedis.log.write "Redis Query (#{(time*1000).round(2)}) => run_query_analyzer(#{model.name}, #{params})"
      res
    end

  end
end