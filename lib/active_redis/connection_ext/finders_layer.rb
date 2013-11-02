module ActiveRedis::ConnectionExt
  module FindersLayer

    def fetch_row(model, id)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_row(#{model.name}, #{id})"
      adapter.hgetall model.table_name(id)
    end

    def fetch_keys(model)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_keys(#{model.name})"
      adapter.keys model.key_name
    end

    def fetch_where(model, params)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_where(#{model.name}, #{params})"
      run_eval :where, [model.key_name], params.flatten
    end

    def fetch_all(model)
      ActiveRedis.log.write "Calling ActiveRedis::ConnectionExt::FindersLayer::fetch_all(#{model.name})"
      fetch_where model, {}
    end

  end
end