require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'

require 'active_redis/inspector'

class TestObject
  def self.attributes_list; []; end
end

describe ActiveRedis::Inspector do

  subject { TestObject.new }

  before do
    TestObject.send :include, ActiveRedis::Inspector
  end

  describe "#inspect" do

    it "is shouldn't be empty" do
      subject.inspect.wont_be_empty
    end

    it "is contains class name" do
      subject.inspect.must_match /TestObject/
    end

    describe "when attributes list isn't blank" do

      before do
        TestObject.stubs(:attributes_list).returns [:attr1]
        subject.stubs(:attr1).returns "attr1_value"
      end

      it "is contains attribute name" do
        subject.inspect.must_match /attr1/
      end

      it "is contains attribute value" do
        subject.inspect.must_match /attr1_value/
      end

    end

  end

end