require "active_redis/version"
require "active_redis/errors"
require "active_redis/railtie" if defined?(Rails)

module ActiveRedis
  autoload :Constants,   'active_redis/constants'
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

  def self.log
    raise ActiveRedis::NoLogError, "Connection not provided!" unless @log
    @log
  end

  def self.log=(value)
    @log = value
  end
end
