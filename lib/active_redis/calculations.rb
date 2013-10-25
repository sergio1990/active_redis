module ActiveRedis
  module Calculations

    def self.extended(base)
      %w{count min max pluck}.each do |method|
        base.instance_eval <<-EVAL
          def #{method}(attribute = "")
            ActiveRedis.connection.calculate_#{method} self, attribute
          end
        EVAL
      end
    end

    # TODO: add average method

  end
end