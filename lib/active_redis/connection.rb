require 'delegate'
require 'redis'

module ActiveRedis
  class Connection < SimpleDelegator

  	alias_method :adapter, :__getobj__

    def initialize(options)
      redis = Redis.new(options)
      super(redis)
    end

    def count_key(key)
    	adapter.eval "return #redis.call('keys', '#{key}*')"
    end

    def next_id(model)
    	table = model.info_table_name
    	create_info_table(model) unless adapter.exists(table)
    	adapter.hincrby table, "next_id", 1
    	adapter.hget table, "next_id"
    end

    def create_info_table(model)
    	adapter.hmset model.info_table_name, "next_id", 0
    end

    def save_table(model, attributes)
    	raise ActiveRedis::NotSpecifiedID, "Must specified ID for saving record!" if !attributes || !attributes[:id]
    	adapter.hmset model.table_name(attributes[:id]), attributes.flatten
    end

    def fetch_row(model, id)
    	adapter.hgetall model.table_name(id)
    end

  end
end