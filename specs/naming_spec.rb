require File.dirname(File.realdirpath(__FILE__)) + '/test_helper.rb'
require 'active_redis/naming'

describe ActiveRedis::Naming do

  subject { TestObject.new }

  before do
    TestObject.send :extend, ActiveRedis::Naming
  end

  describe "#table_name" do

    describe "when id isn't passed" do

      it "is contains pluralize class name" do
        TestObject.table_name.must_match /testobjects\:item\:/
      end

    end

    describe "when id passed" do

      it "is contains passed id" do
        TestObject.table_name("some_id").must_match /testobjects\:item\:some_id/
      end

    end

  end

  describe "#key_name" do

    it "is contains table_name with closing asterisk" do
      TestObject.key_name.must_match /testobjects\:item\:*/
    end

  end

  describe "#info_table_name" do

    it "is consists with pluralize class name and closing 'info'" do
      TestObject.info_table_name.must_match /testobjects\:info/
    end

  end

  describe "#foreign_key_name" do

    it "is contains class name with suffix _id" do
      TestObject.foreign_key_name.must_match /testobject_id/
    end

  end

end