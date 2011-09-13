#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../spec_helper'

module RhnSatellite
  class Test < RhnSatellite::Connection::Base
  end
end

module RhnSatellite
  class Test2 < RhnSatellite::Connection::Base
  end
end

describe RhnSatellite::Connection::Base do
  describe "#reset" do
    it "resets the used base" do
      a = RhnSatellite::Test.send(:base)
      RhnSatellite::Test.reset
      a.should_not eql(RhnSatellite::Test.send(:base))
    end
  end
  
  describe "#base" do
    it "differs based on the used class" do
      RhnSatellite::Test.send(:base).should_not eql(RhnSatellite::Test2.send(:base))
    end
  end

  [:hostname,:username, :password].each do |field|
    describe "##{field}" do
      it "provides a way to set and read a #{field}" do
        RhnSatellite::Test.should respond_to("#{field}=")
        RhnSatellite::Test.should respond_to("#{field}")
      end
      
      it "is used for the base connection" do
        RhnSatellite::Test.reset
        RhnSatellite::Test.send("#{field}=","foo")
        RhnSatellite::Test.send(:base).instance_variable_get("@#{field}").should eql("foo")
      end
    end
  end
  
end  