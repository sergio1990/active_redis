require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/config'

describe ActiveRedis::Config do

  subject { ActiveRedis::Config.new }

  let(:options) { :connection_options }
  let(:adapter) { :adapter }
  let(:log) { :log }

  it "is has connection_options attribute" do
    subject.connection_options = options
    subject.connection_options.must_be_same_as options
  end

  it "is has adapter attribute" do
    subject.adapter = adapter
    subject.adapter.must_be_same_as adapter
  end

  it "is has log attribute" do
    subject.log = log
    subject.log.must_be_same_as log
  end

end