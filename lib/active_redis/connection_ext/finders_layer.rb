module ActiveRedis::ConnectionExt
  module FindersLayer

    def fetch_row(model, id)
      raise ActiveRedis::NotSpecifiedIdError, "Must specified ID for finding record!" unless id
      adapter.hgetall model.table_name(id)
    end

    def fetch_keys(model)
      adapter.keys model.key_name
    end

    def fetch_where(model, params)
      run_eval :where, [model.key_name], params.flatten
    end

    def fetch_all(model)
      fetch_where model, {}
    end

  end
end