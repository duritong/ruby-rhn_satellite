#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../spec_helper'

describe RhnSatellite::Connection::Handler do

  [:hostname,:username, :password].each do |field|
    it "provides a way to set and read a default #{field}" do
      RhnSatellite::Connection::Handler.should respond_to("default_#{field}=")
      RhnSatellite::Connection::Handler.should respond_to("default_#{field}")
    end
  end
  
  describe ".instance_for" do
    it "returns an instance of RhnSatellite::Connection::Handler" do
      RhnSatellite::Connection::Handler.instance_for(:foo).should be_a(RhnSatellite::Connection::Handler) 
    end
    
    it "caches the instances" do
      RhnSatellite::Connection::Handler.instance_for(:foo).should eql(RhnSatellite::Connection::Handler.instance_for(:foo))
    end
    
    it "takes default hostname if no argument is passed" do
      RhnSatellite::Connection::Handler.default_hostname = 'blub'
      RhnSatellite::Connection::Handler.instance_for(:default_hostname).instance_variable_get('@hostname').should eql('blub')
    end
    it "takes passed hostname" do
      RhnSatellite::Connection::Handler.default_hostname = 'blub'
      RhnSatellite::Connection::Handler.instance_for(:default_hostname2,'bla').instance_variable_get('@hostname').should eql('bla')
    end
    
    it "takes default username if no argument is passed" do
      RhnSatellite::Connection::Handler.default_username = 'user'
      RhnSatellite::Connection::Handler.instance_for(:default_user,'bla').instance_variable_get('@username').should eql('user')
    end
    it "takes passed username" do
      RhnSatellite::Connection::Handler.default_username = 'user'
      RhnSatellite::Connection::Handler.instance_for(:default_user2,'bla','user2').instance_variable_get('@username').should eql('user2')
    end

    it "takes default password if no argument is passed" do
      RhnSatellite::Connection::Handler.default_password = 'secret'
      RhnSatellite::Connection::Handler.instance_for(:default_pwd,'bla','user').instance_variable_get('@password').should eql('secret')
    end
    it "takes passed password" do
      RhnSatellite::Connection::Handler.default_password = 'secret'
      RhnSatellite::Connection::Handler.instance_for(:default_pwd2,'bla','user2','secret2').instance_variable_get('@password').should eql('secret2')
    end

    it "takes default timeout if no argument is passed" do
      RhnSatellite::Connection::Handler.default_timeout = 60
      RhnSatellite::Connection::Handler.instance_for(:default_timeout,'bla','user','foo',60).instance_variable_get('@timeout').should eql(60)
    end
    it "takes passed timeout" do
      RhnSatellite::Connection::Handler.default_timeout = 60
      RhnSatellite::Connection::Handler.instance_for(:default_timeout2,'bla','user2','secret2',65).instance_variable_get('@timeout').should eql(65)
    end

    it "defaults https to true" do
      RhnSatellite::Connection::Handler.instance_for(:default_https,'bla','user','secret2').instance_variable_get('@https').should eql(true)
    end
    it "takes passed https setting" do
      RhnSatellite::Connection::Handler.instance_for(:default_https2,'bla','user2','secret2',30,false).instance_variable_get('@https').should eql(false)
    end
  end
  
  describe ".reset" do
    it "removes a cached instance" do
      a = RhnSatellite::Connection::Handler.instance_for(:cache_reset)
      RhnSatellite::Connection::Handler.reset_instance(:cache_reset)
      RhnSatellite::Connection::Handler.instance_for(:cache_reset).should_not eql(a)
    end
    
    it "does not raise an error on an inexistant instance" do
      lambda { RhnSatellite::Connection::Handler.reset_instance(:blablablabla) }.should_not raise_error
    end
  end
  
  describe ".reset_all" do
    it "resets all connections" do
      a = RhnSatellite::Connection::Handler.instance_for(:cache_reset)
      RhnSatellite::Connection::Handler.send(:instances).should_not be_empty
      RhnSatellite::Connection::Handler.reset_all
      RhnSatellite::Connection::Handler.send(:instances).should be_empty
    end
  end

  describe "#connect" do
    before :each do
      RhnSatellite::Connection::Handler.default_hostname = 'connecttest'
    end

    it "creates a new connection with the passed timeout" do
      RhnSatellite::Connection::Handler.default_timeout = 60
      XMLRPC::Client.expects(:new2).with('https://connecttest/rpc/api',nil,60)
      a = RhnSatellite::Connection::Handler.instance_for(:connect)
      a.connect
    end
  end
  
  describe "#disconnect" do
    it "disconnects" do
      a = RhnSatellite::Connection::Handler.instance_for(:disconnect)
      a.connect
      a.connected?.should eql(true)
      a.disconnect
      a.connected?.should eql(false)
    end
  end

  describe "#make_call" do
    context "without a connection"
      it "raises an exception" do
        a = RhnSatellite::Connection::Handler.instance_for(:make_call1)
        a.connected?.should be(false)
        lambda { a.make_call(1,2) }.should raise_error
      end
    end
    
    context "with a connection" do
      it "calls out to xmlrpc" do
        xmlrpc = Object.new
        XMLRPC::Client.expects(:new2).returns(xmlrpc)
        xmlrpc.expects(:call).with(1,2).returns "foo"
        a = RhnSatellite::Connection::Handler.instance_for(:make_call2)
        a.connect
        a.make_call(1,2).should eql('foo')
      end
  end

  describe "#login" do
    it "connects with username and password" do
      a = RhnSatellite::Connection::Handler.instance_for(:login,'blub','user1','password')
      xmlrpc = Object.new
      XMLRPC::Client.expects(:new2).returns(xmlrpc)
      xmlrpc.expects(:call).with('auth.login','user1','password').returns "some_token"
      a.connect
      a.login
    end
    
    it "connects with a duration" do
      a = RhnSatellite::Connection::Handler.instance_for(:login2,'blub','user1','password')
      xmlrpc = Object.new
      XMLRPC::Client.expects(:new2).returns(xmlrpc)
      xmlrpc.expects(:call).with('auth.login','user1','password',10).returns "some_token2"
      a.connect
      a.login(10)
    end
    
    it "does not call login again if we are logged in" do
      a = RhnSatellite::Connection::Handler.instance_for(:login3,'blub','user1','password')
      xmlrpc = Object.new
      XMLRPC::Client.expects(:new2).returns(xmlrpc)
      xmlrpc.expects(:call).with('auth.login','user1','password').returns "some_token3"
      a.connect
      a.login.should(eql("some_token3"))
      a.login.should(eql("some_token3"))
    end
  end
  
  describe "#logout" do
    it "calls logout and clears the auth_token" do
      a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
      xmlrpc = Object.new
      XMLRPC::Client.expects(:new2).returns(xmlrpc)
      xmlrpc.expects(:call).with('auth.login','user1','password').returns "some_token4"
      xmlrpc.expects(:call).with('auth.logout','some_token4')
      a.connect
      a.login.should(eql("some_token4"))
      a.logout.should(eql(true))
      a.instance_variable_get("@auth_token").should be_nil
    end
    
    it "should not logout if we're not logged in" do
      a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
      xmlrpc = Object.new
      XMLRPC::Client.expects(:new2).returns(xmlrpc)
      xmlrpc.expects(:call).with('auth.logout','some_token4').never
      a.connect
      a.logout.should(eql(true))
      a.instance_variable_get("@auth_token").should be_nil
    end
  end
  
  describe "#in_transaction" do
    context "with login" do
      it "logs in and out" do
        a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
        xmlrpc = Object.new
        XMLRPC::Client.expects(:new2).returns(xmlrpc)
        a.expects(:login).once
        a.expects(:logout).once
        
        a.in_transaction(true){ "block" }.should eql("block")
      end
      it "passes the token to the block" do
        a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
        xmlrpc = Object.new
        XMLRPC::Client.expects(:new2).returns(xmlrpc)
        xmlrpc.expects(:call).with('auth.login','user1','password').returns "some_token5"
        a.expects(:logout).once
        
        a.in_transaction(true){|token| token.should eql("some_token5"); "block" }.should eql("block")        
      end
    end
    context "without login" do
      it "does not log in and out" do
        a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
        xmlrpc = Object.new
        XMLRPC::Client.expects(:new2).returns(xmlrpc)
        a.expects(:login).never
        a.expects(:logout).never
        
        a.in_transaction{ "block" }.should eql("block")
      end
    end
  end
  describe "#default_call" do
    it "delegates everything to a logged in transaction" do
        a = RhnSatellite::Connection::Handler.instance_for(:logout,'blub','user1','password')
        a.stubs(:make_call).with('auth.login','user1','password').returns "some_token5"
        a.expects(:logout).twice
        a.expects(:make_call).with('some_method','some_token5','arg1','arg2').returns("result")
        a.expects(:make_call).with('some_method2','some_token5').returns("result2")

        a.default_call('some_method','arg1','arg2').should eql('result')
        a.default_call('some_method2').should eql('result2')
    end
  end
end
