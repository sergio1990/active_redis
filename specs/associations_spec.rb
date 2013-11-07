require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/associations'
require 'active_redis/constants'
require 'active_redis/errors'

module ActiveRedis
  module Associations
    class SomeAssociation
      def initialize(name, target);end
    end
  end
end

TestObject.class_eval do
  def save;end
end

describe ActiveRedis::Associations do

  subject { TestObject.new }

  before do
    TestObject.send :include, ActiveRedis::Associations
  end

  it "is has associations attribute" do
    TestObject.must_respond_to :associations
    TestObject.must_respond_to :associations=
  end

  describe "class methods" do

    describe "#association" do

      describe "when al least one association registered" do

        let(:some_assoc) { mock() }

        before do
          TestObject.associations = {assoc: some_assoc}
        end

        it "is return registered association by name" do
          TestObject.association(:assoc).must_be_same_as some_assoc
        end

      end

      describe "when try to fetch unregistered association" do

        before do
          TestObject.associations = {}
        end

        it "is raise UnregisteredAssociationError" do
          lambda{
            TestObject.association(:assoc)
          }.must_raise(ActiveRedis::UnregisteredAssociationError)
        end

      end

    end

    ActiveRedis::Constants::ASSOCIATIONS.each do |assoc|
      describe "##{assoc}" do

        it "is register #{assoc} association with name" do
          TestObject.expects(:register_association).with(:object, assoc.to_sym, {}).returns true
          TestObject.send assoc, :object
        end

      end
    end

    describe "private methods" do

      describe "#register_association" do

        let(:assoc) { mock() }

        it "is create certain class by assoc name" do
          ActiveRedis::Associations::SomeAssociation.expects(:new).with(:object, TestObject, {}).returns assoc
          TestObject.send :register_association, :object, :some, {}
          TestObject.associations.must_be :has_key?, :object
        end

      end

    end

  end

end