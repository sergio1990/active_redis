require 'active_redis/attributes'
require 'active_redis/associations'
require 'active_redis/persistence'
require 'active_redis/naming'
require 'active_redis/calculations'

module ActiveRedis
  class Base
    extend Naming
    extend Calculations

    include Attributes
    include Associations
    include Persistence

  end
end