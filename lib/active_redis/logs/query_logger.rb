require 'benchmark'

module ActiveRedis
  module Logs
    module QueryLogger

      def loggable(*methods)
        str_eval = ""
        methods.each do |method|
          str_eval += <<-CODE

            def #{method}_with_loggable(*args)
              res = nil
              time = Benchmark.realtime do
                res = #{method}_without_loggable(*args)
              end
              ActiveRedis.log.write "  Redis Query (\#{(time*1000).round(2)}ms) => #{method}(\#{args})"
              res
            end

            alias_method_chain :#{method}, :loggable
          CODE
        end
        class_eval(str_eval)
      end

    end
  end
end