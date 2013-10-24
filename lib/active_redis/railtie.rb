module ActiveRedis
  class Railtie < Rails::Railtie
    config.after_initialize do
      ActiveRedis.connection = ActiveRedis::Connection.new(ActiveRedis.config.connection_options || {})
    end
  end
end