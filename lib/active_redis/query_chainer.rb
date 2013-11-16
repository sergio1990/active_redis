require 'active_redis/relation'
require 'active_redis/query_iterator'

module ActiveRedis
  autoload :QueryExecutor, 'active_redis/query_executor'

  class QueryChainer
    include Relation
    include QueryIterator

    def initialize(target)
      @where_options = {}
      @order_options = {id: :asc}
      @limit_options = {per_page: 10, page: 0}
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

    def apply_top(options)
      apply_limit per_page: 1, page: 0
    end

    def apply_all(options)
      apply_limit Hash.new
    end

    def reload
      @collection = nil
    end

    def linked_objects
      @collection ||= objects_by_query
    end

    private

    def execute_query
      QueryExecutor.execute(@target, @where_options, @order_options, @limit_options)
    end

    def objects_by_query
      res = execute_query.inject([]) { |arr, attrs| arr << @target.new(attrs) if attrs && attrs.any?; arr }
      top_limit? ? res.first : res
    end

    def top_limit?
      @limit_options[:per_page] == 1 && @limit_options[:page] == 0
    end

  end
end