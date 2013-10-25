require 'active_redis/helpers/lua_scripts'
Dir[File.dirname(__FILE__) + '/connection_ext/*.rb'].each {|file| require file }
include ActiveRedis::Helpers::LuaScripts

module ActiveRedis
  class Connection
    extend ActiveRedis::ConnectionExt::Calculations

    def initialize(options, adapter)
      @adapter = adapter.new(options)
    end

    calculations ActiveRedis::Constants::CALCULATION_METHODS

    def next_id(model)
      table = model.info_table_name
      create_info_table(model) unless @adapter.exists(table)
      @adapter.hincrby table, "next_id", 1
      @adapter.hget table, "next_id"
    end

    def create_info_table(model)
      @adapter.hmset model.info_table_name, "next_id", 0
    end

    def save_table(model, attributes)
      raise ActiveRedis::NotSpecifiedID, "Must specified ID for saving record!" if !attributes || !attributes[:id]
      @adapter.hmset model.table_name(attributes[:id]), attributes.flatten
    end

    def fetch_row(model, id)
      @adapter.hgetall model.table_name(id)
    end

  end
end