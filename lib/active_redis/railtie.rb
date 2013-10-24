module ActiveRedis
  class Railtie < Rails::Railtie
    config.after_initialize do
      # TODO: Add code for creating connection to Redis
    end
  end
end