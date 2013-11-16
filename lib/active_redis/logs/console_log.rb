require_relative './basic_log'
require 'colorize'

module ActiveRedis
  module Logs
    class ConsoleLog < BasicLog

      def write(message)
        puts message.green
      end

    end
  end
end