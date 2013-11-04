require 'active_redis/relation'

module ActiveRedis
  autoload :QueryExecutor, 'active_redis/query_executor'

  class QueryChainer
    include Relation

    def initialize(target)
      @where_options = {}
      @order_options = {id: :asc}
      @limit_options = {per_page: 10, page: 0}
      @target = target
      @first = false
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
      @first = false
      self
    end

    def apply_first(options)
      @limit_options = {per_page: 1, page: 0}
      @first = true
      self
    end

    def inspect
      if object.is_a? Array
        "[#{object.map{|e| e.inspect}.join(', ')}]"
      else
        object.inspect
      end
    end

    private

    def object
      @object ||= objects_by_query
    end

    def execute_query
      QueryExecutor.execute(@target, @where_options, @order_options, @limit_options)
    end

    def objects_by_query
      res = execute_query.map { |attrs| @target.new(attrs) }
      @first ? res.first : res
    end

  end
end