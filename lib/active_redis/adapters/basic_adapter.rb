require 'delegate'
require 'redis'

module ActiveRedis
  module Adapters

    class BasicAdapter < SimpleDelegator

      alias_method :adapter, :__getobj__

      def initialize(options)
        redis = Redis.new(options)
        super(redis)
      end

    end

  end
end