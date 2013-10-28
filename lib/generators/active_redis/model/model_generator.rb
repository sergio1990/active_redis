require 'generators/active_redis'

module ActiveRedis
  module Generators
    class ModelGenerator < Base
      argument :actions, type: :array, default: [], banner: "attribute attribute"

      def create_model
        template 'model.rb', File.join('app/models', "#{file_name}.rb")
      end

    end
  end
end