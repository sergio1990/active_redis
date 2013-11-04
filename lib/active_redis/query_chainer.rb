require 'active_redis/relation'

module ActiveRedis
  class QueryChainer
    include Relation

    def initialize(target)
      @where_options = {}
      @order_options = {id: :asc}
      @limit_options = []
      @target = target
    end

    def apply_where(options)
      @where_options.merge!(options)
      self
    end

    def apply_order(options)
      @order_options = options if options.any?
      self
    end

    def apply_limit(options)
      @limit_options = options
      self
    end

  end
end