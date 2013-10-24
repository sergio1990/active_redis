require 'delegate'
require 'redis'

module ActiveRedis
  class Connection < SimpleDelegator

    def initialize(options)
      redis = Redis.new(options)
      super(redis)
    end

  end
end