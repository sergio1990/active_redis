require 'active_redis/logs/query_logger'

module ActiveRedis::ConnectionExt
  module FindersLayer

    def self.included(base)
      base.send :extend, ActiveRedis::Logs::QueryLogger
      base.loggable :run_query_analyzer
    end

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

    def run_query_analyzer(model, params = ["", "", "", ""])
      run_eval :query_analyzer, [model.key_name, Time.now.to_i], params
    end

  end
end