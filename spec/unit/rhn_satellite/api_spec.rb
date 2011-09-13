#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Api do
  before(:each) { RhnSatellite::Api.reset }
  
  {:api_version => "getVersion", :satellite_version => "systemVersion" }.each do |m,cmd|
    describe ".#{m.to_s}" do
      it "gets the version and disconnects by default" do
        conn = Object.new
        conn.stubs(:call)
        
        XMLRPC::Client.expects(:new2).returns(conn)
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("api.#{cmd}").returns("2.0")
        
        RhnSatellite::Api.send(m).should eql("2.0")
        RhnSatellite::Api.send(:base).connected?.should eql(false)
      end
      
      it "caches the version" do
        conn = Object.new
        conn.stubs(:call)
        
        XMLRPC::Client.expects(:new2).returns(conn)
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("api.#{cmd}").once.returns("2.0")
        
        RhnSatellite::Api.send(m).should eql("2.0")
        RhnSatellite::Api.send(m).should eql("2.0")
        RhnSatellite::Api.send(:base).connected?.should eql(false)
      end
      
      it "does not disconnect if told so" do
        conn = Object.new
        conn.stubs(:call)
        
        XMLRPC::Client.expects(:new2).returns(conn)
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("api.#{cmd}").returns("2.0")
        
        RhnSatellite::Connection::Handler.any_instance.expects(:disconnect).never
        
        RhnSatellite::Api.send(m,false).should eql("2.0")
        RhnSatellite::Api.send(:base).connected?.should eql(true)
      end
    end
  end
  describe ".reset" do
    it "resets the versions" do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("api.getVersion").returns("2.0")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("api.systemVersion").returns("2.0")
      
      RhnSatellite::Api.api_version.should eql("2.0")
      RhnSatellite::Api.satellite_version.should eql("2.0")
      
      RhnSatellite::Api.reset
      
      RhnSatellite::Api.instance_variable_get("@api_version").should be_nil
      RhnSatellite::Api.instance_variable_get("@satellite_version").should be_nil
    end
  end
  
  describe ".test_connection" do
    it "runs a test login and logout" do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::Api.username = 'user'
      RhnSatellite::Api.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      
      RhnSatellite::Api.test_connection.should eql(true)
    end

    it "runs a test login and logout with a dediacted user and pwd" do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::Api.username = 'user'
      RhnSatellite::Api.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user2','pwd2').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
      
      RhnSatellite::Api.test_connection('user2','pwd2').should eql(true)
    end
  end
end