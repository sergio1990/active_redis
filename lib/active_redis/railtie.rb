require 'active_redis/adapters/basic_adapter'

module ActiveRedis
  class Railtie < Rails::Railtie
    config.after_initialize do
      ActiveRedis.connection = ActiveRedis::Connection.new(
      	ActiveRedis.config.connection_options || {},
      	ActiveRedis.config.adapter || ActiveRedis::Adapters::BasicAdapter
      )
    end
  end
end