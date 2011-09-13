#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Channel do
  before(:each) { RhnSatellite::Channel.reset }
  
  describe ".all" do
    before(:each) do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::Channel.username = 'user'
      RhnSatellite::Channel.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    it "logins and returns a bunch of channels" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("channel.listSoftwareChannels","token").returns(["123","234"])

      RhnSatellite::Channel.all.should eql(["123","234"])
    end
    
    it "returns an empty array on an empty answer" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("channel.listSoftwareChannels","token").returns(nil)

      RhnSatellite::Channel.all.should eql([])      
    end
    
    it "iterates the items over the block" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("channel.listSoftwareChannels","token").returns(["123","234"])
      RhnSatellite::Channel.all{|i| ["123","234"].include?(i).should be_true }.should eql(["123","234"])
    end
  end
end