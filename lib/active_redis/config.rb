class ActiveRedis::Config
  # Specify connection string to Redis. To check all available options please see redis-rb library.
  #
  # Some samples:
  #   ActiveRedis.config.connection_options = {host: 10.10.1.1, port: 6380}
  # or
  #   ActiveRedis.config.connection_options = {path: '/tmp/redis.sock'}
  attr_accessor :connection_options

  # Specify adapter for connection to DB
  # By default it's ActiveRedis::Adapters::BasicAdapter
  attr_accessor :adapter

  # Specify log
  # By default it's ActiveRedis::Logs::ConsoleLog
  attr_accessor :log
end