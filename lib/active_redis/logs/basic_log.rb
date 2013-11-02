module ActiveRedis
  module Logs
    class BasicLog

      def write(message)
        raise NotImplementedError
      end

    end
  end
end