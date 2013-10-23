require "active_redis/version"

module ActiveRedis
  autoload :Config, 'active_redis/config'

  def self.config(&block)
    @config ||= ::ActiveRedis::Config.new
    block_given? ? yield(@config) : @config
  end
end
