#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::ActivationKey do
  before(:each) { RhnSatellite::ActivationKey.reset }
  
  describe ".all" do
    before(:each) do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::ActivationKey.username = 'user'
      RhnSatellite::ActivationKey.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    it "logins and returns a bunch of activation keys" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("activationkey.listActivationKeys","token").returns(["123","234"])

      RhnSatellite::ActivationKey.all.should eql(["123","234"])
    end
    
    it "returns an empty array on an empty answer" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("activationkey.listActivationKeys","token").returns(nil)

      RhnSatellite::ActivationKey.all.should eql([])      
    end
    
    it "iterates the items over the block" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("activationkey.listActivationKeys","token").returns(["123","234"])
      RhnSatellite::ActivationKey.all{|i| ["123","234"].include?(i).should be_true }.should eql(["123","234"])
    end
    describe ".get" do
      context "with keys" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('activationkey.listActivationKeys',"token").returns([{'name' => "123"},{'name' => "234"}])
        end
        it "finds a key in all keys" do
          RhnSatellite::ActivationKey.get('123').should eql({'name' => '123'})
        end

        it "returns nil on an non-existant key" do
          RhnSatellite::ActivationKey.get('12333').should eql(nil)
        end
      end
      context "without any keys" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('activationkey.listActivationKeys',"token").returns([])
        end
        it "returns nil" do
          RhnSatellite::ActivationKey.get('12333').should eql(nil)
        end
      end
    end
  end
end
