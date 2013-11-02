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

  end
end