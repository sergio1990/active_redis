require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/calculations'
require 'active_redis/constants'
require 'active_redis/errors'

describe ActiveRedis::Calculations do

  let(:connection) { mock() }

  before do
    TestObject.send :extend, ActiveRedis::Calculations
    ActiveRedis.stubs(:connection).returns connection
  end

  ActiveRedis::Constants::CALCULATION_METHODS.each do |method|

    describe "##{method}" do

      it "is call #{method} calculate on connection" do
        connection.expects("calculate_#{method}")
        TestObject.send method
      end

    end

  end

end