module ActiveRedis
  module Calculations

    def self.extended(base)
      ActiveRedis::Constants::CALCULATION_METHODS.each do |method|
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