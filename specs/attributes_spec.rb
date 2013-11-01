require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/attributes'
require 'active_redis/constants'
require 'active_redis/errors'

module ActiveRedis
  module Attributes
    class SomeAttribute
      def load(value);end
      def dump(value);end
    end
  end
end

describe ActiveRedis::Attributes do

  subject { TestObject.new }

  before do
    TestObject.send :include, ActiveRedis::Attributes
  end

  describe "instance methods" do

    describe "#attributes=" do

      describe "when passing invalid value" do

        it "is raise InvalidArgumentError" do
          lambda{
            subject.send :attributes=, :bad_value
          }.must_raise ActiveRedis::InvalidArgumentError
        end

      end

      describe "when passing valid value" do

        describe "when value is Hash" do

          it "is mapping passing values to attributes" do
            subject.expects(:attr1=).with(:attr1_value)
            lambda{
              subject.send :attributes=, attr1: :attr1_value
            }.must_be_silent
          end

        end

        describe "when value is Array" do

          it "is mapping passing values to attributes" do
            subject.expects(:attr1=).with(:attr1_value)
            lambda{
              subject.send :attributes=, [:attr1, :attr1_value]
            }.must_be_silent
          end

        end

      end

    end

    describe "#attributes" do

      before do
        TestObject.stubs(:attributes_list).returns [:attr1]
        subject.stubs(:attr1).returns :attr1_value
      end

      it "is return attributes hash" do
        attrs = subject.attributes
        attrs.must_be :count, 1
        attrs.must_include :attr1
      end

    end

  end

  describe "class methods" do

    describe "#attributes" do

      describe "when passing valid value" do

        it "is raise InvalidArgumentError" do
          lambda{
            TestObject.attributes :attr1
          }.must_raise ActiveRedis::InvalidArgumentError
        end

      end

      describe "when passing Hash value" do

        before do
          ActiveRedis::Constants::DEFAULT_ATTRIBUTES = {}
        end

        it "is call define_attributes_accessors" do
          TestObject.expects(:define_attributes_accessors).with(attr1: :some)
          lambda{
            TestObject.attributes attr1: :some
          }.must_be_silent
          TestObject.must_respond_to :defined_attributes
        end

      end

    end

    describe "#define_attributes_accessors" do

      describe "when attribute is already registered" do

        it "is doesn't define accessors functions" do
          TestObject.expects(:read_attribute).at_least 0
          TestObject.expects(:write_attribute).at_least 0
          TestObject.expects(:register_attribute).with(:attr1, :some).returns false
          TestObject.define_attributes_accessors attr1: :some
        end

      end

      describe "when trying define new attribute" do

        it "is define read/write attribute's functions" do
          TestObject.expects(:read_attribute).with(:attr1)
          TestObject.expects(:write_attribute).with(:attr1)
          TestObject.expects(:register_attribute).with(:attr1, :some).returns true
          TestObject.define_attributes_accessors attr1: :some
        end

      end

    end

    describe "#attributes_list" do

      before do
        TestObject.defined_attributes = {attr1: :some}
      end

      it "is return array with attributes names" do
        TestObject.attributes_list.must_equal ["attr1"]
      end

    end

    describe "private methods" do

      describe "#register_attribute" do

        describe "when attribute already exists" do

          before do
            TestObject.defined_attributes = {attr1: :some}
          end

          it "is return false" do
            result = TestObject.send :register_attribute, :attr1, :some
            result.must_equal false
          end

        end

        describe "when try to register new attribute" do

          before do
            TestObject.defined_attributes = {}
          end

          it "is return true" do
            result = TestObject.send :register_attribute, :attr1, :some
            TestObject.defined_attributes.must_include :attr1
            result.must_equal true
          end

        end

      end

      describe "#attribute_class" do

        before do
          TestObject.defined_attributes = {attr1: {class: :attr1_class}}
        end

        it "is return associated class" do
          result = TestObject.send :attribute_class, :attr1
          result.must_equal :attr1_class
        end

      end

      describe "#read_attribute" do

        it "is define read method for attribute" do
          TestObject.expects(:define_method).with(:attr1)
          TestObject.send :read_attribute, :attr1
        end

      end


      describe "#write_attribute" do

        it "is define write method for attribute" do
          TestObject.expects(:define_method).with("attr1=")
          TestObject.send :write_attribute, :attr1
        end

      end

    end

  end

end