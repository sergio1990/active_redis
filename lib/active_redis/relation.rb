require 'active_redis/constants'

module ActiveRedis
  autoload :QueryChainer,   'active_redis/query_chainer'
  module Relation

    %w{where order limit top all}.concat(ActiveRedis::Constants::CALCULATION_METHODS).each do |method|
      class_eval <<-CODE
        def #{method}(options = {})
          if self.class.name == "ActiveRedis::QueryChainer"
            self.apply_#{method}(options)
          else
            QueryChainer.new(self).apply_#{method}(options)
          end
        end
      CODE
    end

  end
end