require 'active_redis/attributes'
require 'active_redis/associations'
require 'active_redis/persistence'
require 'active_redis/naming'
require 'active_redis/calculations'
require 'active_redis/finders'
require 'active_redis/inspector'
require 'active_redis/relation'

# TODO: Add Expiring module

module ActiveRedis
  class Base
    extend Naming
    extend Calculations
    extend Finders
    extend Relation

    include Attributes
    include Persistence
    include Associations
    include Inspector
    include Relation

  end
end