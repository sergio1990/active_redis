module ActiveRedis::ConnectionExt
  module PersistenceLayer

    def save_table(model, attributes)
      raise ActiveRedis::NotSpecifiedIdError, "Must specified ID for saving record!" if !attributes || !attributes[:id]
      adapter.hmset model.table_name(attributes[:id]), attributes.flatten
    end

    def next_id(model)
      table = model.info_table_name
      create_info_table(model) unless @adapter.exists(table)
      adapter.hincrby table, "next_id", 1
      adapter.hget table, "next_id"
    end

    def create_info_table(model)
      adapter.hmset model.info_table_name, "next_id", 0
    end

    def destroy(model, id)
      raise ActiveRedis::NotSpecifiedIdError, "Must specified ID for destroy record!" unless id
      destroy_by_keys model.table_name(id)
    end

    def destroy_all(model)
      destroy_by_keys fetch_keys(model)
    end

    private
    def destroy_by_keys(keys)
      adapter.del keys
    end

  end
end