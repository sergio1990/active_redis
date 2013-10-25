module ActiveRedis
  module Helpers
    module LuaScripts

      %w{count pluck min max sum}.each do |method|
        define_method "#{method}_script" do
          <<-LUA
            #{LuaLoader.get_main}
            return calculate_#{method}(KEYS[1]#{method == "count" ? "" : ", ARGV[1]"})
          LUA
        end
      end

      class LuaLoader

        def self.get_main
          @content ||= File.read(File.dirname(__FILE__) + '/../lua_scripts/main.lua')
        end

      end

    end
  end
end