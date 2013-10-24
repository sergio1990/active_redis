require "active_redis/version"
require "active_redis/errors"
require "active_redis/railtie" if defined?(Rails)

module ActiveRedis
  autoload :Config,      'active_redis/config'
  autoload :Base,        'active_redis/base'
  autoload :Connection,  'active_redis/connection'

  def self.config(&block)
    @config ||= ::ActiveRedis::Config.new
    block_given? ? yield(@config) : @config
  end

  def self.connection
    raise ActiveRedis::NoConnectionError, "Connection not provided!" unless @connection
    @connection
  end

  def self.connection=(value)
    @connection = value
  end
end
