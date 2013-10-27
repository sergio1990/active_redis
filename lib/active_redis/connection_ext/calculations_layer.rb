module ActiveRedis::ConnectionExt
  module CalculationsLayer

    def self.extended(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def calculations(methods)
        eval_string = ""
        methods.each do |method|
          eval_string += <<-EVAL
            def calculate_#{method}(model, attributes = "")
              adapter.eval send("#{method}_script"), keys: [model.key_name], argv: [attributes]
            end
          EVAL
        end
        class_eval(eval_string)
      end
    end

  end
end