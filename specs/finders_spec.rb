require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/finders'
require 'active_redis/constants'
require 'active_redis/errors'

describe ActiveRedis::Finders do

  let(:connection) { mock() }

  before do
    TestObject.send :extend, ActiveRedis::Finders
    ActiveRedis.stubs(:connection).returns connection
  end

  describe "#find" do

    describe "when passed single value" do

      describe "when entry finded" do

        let(:entry) { mock() }
        let(:attributes) { {attr1: :value} }

        it "is return related object" do
          connection.expects(:fetch_row).with(TestObject, 1).returns attributes
          TestObject.expects(:new).with(attributes).returns entry
          TestObject.find(1).must_equal entry
        end

      end

      describe "when nothing finded" do

        it "is return nil" do
          connection.expects(:fetch_row).with(TestObject, 1).returns []
          TestObject.expects(:new).at_least 0
          TestObject.find(1).must_be_nil
        end

      end

    end

    describe "when passed several ids" do

      describe "when entries finded" do

        let(:entry) { mock() }
        let(:attributes) { {attr1: :value} }

        it "is return array of objects" do
          connection.expects(:fetch_row).with(TestObject, 1).returns attributes
          connection.expects(:fetch_row).with(TestObject, 2).returns attributes
          TestObject.expects(:new).with(attributes).returns(entry).at_least 2
          TestObject.find(1, 2).must_be :count, 2
        end

      end

    end

  end

  describe "#where" do

    describe "when empty search result" do

      it "is return empty array" do
        connection.expects(:fetch_where).with(TestObject, :params).returns []
        TestObject.expects(:new).at_least 0
        TestObject.where(:params).must_be_empty
      end

    end

    describe "when something will find" do

      let(:object) { mock() }

      it "is return array of objects" do
        connection.expects(:fetch_where).with(TestObject, :params).returns [:attrs]
        TestObject.expects(:new).with(:attrs).returns(object).at_least 1
        result = TestObject.where(:params)
        result.wont_be_empty
        result.must_include object
        result.must_be :count, 1
      end

    end

  end

  describe "#all" do

    it "is call where with empty params" do
      TestObject.expects(:where).with().returns []
      TestObject.all
    end

  end

end