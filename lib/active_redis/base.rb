require 'active_redis/attributes'
require 'active_redis/associations'

module ActiveRedis
  class Base

    include Attributes
    include Associations

  end
end