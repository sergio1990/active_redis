module ActiveRedis
  module Helpers
    module LuaScripts

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

    end
  end
end