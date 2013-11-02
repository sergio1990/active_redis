require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/config'

describe ActiveRedis::Config do

  subject { ActiveRedis::Config.new }

  let(:options) { :connection_options }
  let(:adapter) { :adapter }

  it "is has connection_options attribute" do
    subject.connection_options = options
    subject.connection_options.must_be_same_as options
  end

  it "is has adapter attribute" do
    subject.adapter = adapter
    subject.adapter.must_be_same_as adapter
  end

end