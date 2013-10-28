require 'active_redis/helpers/lua_scripts'
Dir[File.dirname(__FILE__) + '/connection_ext/*.rb'].each {|file| require file }

include ActiveRedis::Helpers::LuaScripts

module ActiveRedis
  class Connection
    extend ActiveRedis::ConnectionExt::CalculationsLayer

    include ActiveRedis::ConnectionExt::FindersLayer
    include ActiveRedis::ConnectionExt::PersistenceLayer
    include ActiveRedis::ConnectionExt::ScriptsLayer

    calculations ActiveRedis::Constants::CALCULATION_METHODS

    def initialize(options, adapter)
      @adapter = adapter.new(options)
    end

    attr_accessor :adapter

    private

    def run_eval(type, keys = [], argv = [])
      adapter.eval send("#{type}_script"), keys: keys, argv: argv
    end

  end
end