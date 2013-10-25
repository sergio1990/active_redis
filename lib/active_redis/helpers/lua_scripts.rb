module ActiveRedis
  module Helpers
    module LuaScripts

      def count_script
        return <<-COUNT
          return #redis.call('keys', KEYS[1])
        COUNT
      end

      def pluck_script
        return <<-PLUCK
          local result = {}
          local keys = redis.call("KEYS", KEYS[1])
          for index, key in pairs(keys) do
            table.insert(result, redis.call("HGET", key, ARGV[1]))
          end
          return result
        PLUCK
      end

      def max_script
        return <<-MAX
          local result = {}
          local keys = redis.call("KEYS", KEYS[1])
          for index, key in pairs(keys) do
            table.insert(result, tonumber(redis.call("HGET", key, ARGV[1])))
          end
          table.sort(result)
          return result[#result]
        MAX
      end

      def min_script
        return <<-MAX
          local result = {}
          local keys = redis.call("KEYS", KEYS[1])
          for index, key in pairs(keys) do
            table.insert(result, tonumber(redis.call("HGET", key, ARGV[1])))
          end
          table.sort(result)
          return result[1]
        MAX
      end

      def sum_script
        return <<-MAX
          local result = {}
          local keys = redis.call("KEYS", KEYS[1])
          local sum = 0
          for index, key in pairs(keys) do
            sum = sum + tonumber(redis.call("HGET", key, ARGV[1]))
          end
          return sum
        MAX
      end

    end
  end
end