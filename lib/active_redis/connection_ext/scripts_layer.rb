module ActiveRedis::ConnectionExt
  module ScriptsLayer

    def flush_script
      adapter.script :flush
    end

  end
end