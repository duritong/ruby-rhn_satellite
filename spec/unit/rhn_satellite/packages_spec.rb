#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Packages do
  before(:each) do
    RhnSatellite::Packages.reset
    conn = Object.new
    conn.stubs(:call)
      
    XMLRPC::Client.stubs(:new2).returns(conn)
      
    RhnSatellite::Packages.username = 'user'
    RhnSatellite::Packages.password = 'pwd'
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
  end

  describe ".details" do
    before(:each) do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    it "should return details" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("packages.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Packages.details(1).should eql({"name" => 'foo'})
    end
    it "should convert the id" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("packages.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Packages.details('1').should eql({"name" => 'foo'})
    end
  end

  describe ".exists?" do
    it "should return true if we get a result" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("packages.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Packages.exists?(1).should be_true
    end
    it "should return false if we don't get a result" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("packages.getDetails",'token',1).returns(nil)

      RhnSatellite::Packages.exists?(1).should be_false
    end
    it "should return false if am exception is raised" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("packages.getDetails",'token',1).raises(XMLRPC::FaultException.new(500,"blub"))

      RhnSatellite::Packages.exists?(1).should be_false
    end
  end
end
