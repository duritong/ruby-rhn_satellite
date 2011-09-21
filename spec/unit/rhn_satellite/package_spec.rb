#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Package do
  before(:each) do
    RhnSatellite::Package.reset
    conn = Object.new
    conn.stubs(:call)
      
    XMLRPC::Client.stubs(:new2).returns(conn)
      
    RhnSatellite::Package.username = 'user'
    RhnSatellite::Package.password = 'pwd'
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
  end

  describe ".details" do
    before(:each) do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    it "should return details" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("package.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Package.details(1).should eql({"name" => 'foo'})
    end
    it "should convert the id" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("package.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Package.details('1').should eql({"name" => 'foo'})
    end
  end

  describe ".exists?" do
    it "should return true if we get a result" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("package.getDetails",'token',1).returns({"name" => 'foo'})

      RhnSatellite::Package.exists?(1).should be_true
    end
    it "should return false if we don't get a result" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("package.getDetails",'token',1).returns(nil)

      RhnSatellite::Package.exists?(1).should be_false
    end
    it "should return false if am exception is raised" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("package.getDetails",'token',1).raises(XMLRPC::FaultException.new(500,"blub"))

      RhnSatellite::Package.exists?(1).should be_false
    end
  end
end
