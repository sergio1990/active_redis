module ActiveRedis
  module Helpers
    module LuaScripts

      def count_script
        return <<-COUNT
          #{LuaLoader.get_main}
          return calculate_count(KEYS[1])
        COUNT
      end

      def pluck_script
        return <<-COUNT
          #{LuaLoader.get_main}
          return calculate_pluck(KEYS[1], ARGV[1])
        COUNT
      end

      def min_script
        return <<-COUNT
          #{LuaLoader.get_main}
          return calculate_min(KEYS[1], ARGV[1])
        COUNT
      end

      def max_script
        return <<-COUNT
          #{LuaLoader.get_main}
          return calculate_max(KEYS[1], ARGV[1])
        COUNT
      end

      def sum_script
        return <<-COUNT
          #{LuaLoader.get_main}
          return calculate_sum(KEYS[1], ARGV[1])
        COUNT
      end

      class LuaLoader

        def self.get_main
          @content ||= File.read(File.dirname(__FILE__) + '/../lua_scripts/main.lua')
        end

      end

    end
  end
end