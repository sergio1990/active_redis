require 'active_redis/adapters/basic_adapter'
require 'active_redis/logs/console_log'

module ActiveRedis
  class Railtie < Rails::Railtie
    config.after_initialize do
      ActiveRedis.connection = ActiveRedis::Connection.new(
        ActiveRedis.config.connection_options || {},
        ActiveRedis.config.adapter || ActiveRedis::Adapters::BasicAdapter
      )
      ActiveRedis.log = (ActiveRedis.config.log || ActiveRedis::Logs::ConsoleLog).new
    end
  end
end