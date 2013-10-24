require 'delegate'
require 'redis'

module ActiveRedis
  class Connection < SimpleDelegator

    def initialize(options)
      redis = Redis.new(options)
      super(redis)
    end

    def count_key(key)
    	__getobj__.eval "return #redis.call('keys', '#{key}*')"
    end

  end
end