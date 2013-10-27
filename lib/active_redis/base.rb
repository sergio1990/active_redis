require 'active_redis/attributes'
require 'active_redis/associations'
require 'active_redis/persistence'
require 'active_redis/naming'
require 'active_redis/calculations'
require 'active_redis/finders'

# TODO: Add Expiring module

module ActiveRedis
  class Base
    extend Naming
    extend Calculations
    extend Finders

    include Attributes
    include Associations
    include Persistence

  end
end