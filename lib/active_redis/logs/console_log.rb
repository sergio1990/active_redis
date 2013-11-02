require_relative './basic_log'

module ActiveRedis
  module Logs
    class ConsoleLog < BasicLog

      def write(message)
        puts message
      end

    end
  end
end