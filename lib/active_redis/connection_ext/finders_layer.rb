module ActiveRedis::ConnectionExt
  module FindersLayer

    def fetch_row(model, id)
      raise ActiveRedis::NotSpecifiedIdError, "Must specified ID for finding record!" unless id
      @adapter.hgetall model.table_name(id)
    end

  end
end