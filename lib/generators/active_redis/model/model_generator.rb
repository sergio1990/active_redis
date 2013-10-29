require 'generators/active_redis'

module ActiveRedis
  module Generators
    class ModelGenerator < Base
      argument :actions, type: :array, default: [], banner: "attribute:type attribute:type"

      def create_model
        template 'model.rb', File.join('app/models', "#{file_name}.rb")
      end

    end
  end
end