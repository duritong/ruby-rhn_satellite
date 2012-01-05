#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::ChannelAccess do
  before(:each) do
    RhnSatellite::ChannelAccess.reset
    conn = Object.new
    conn.stubs(:call)
      
    XMLRPC::Client.stubs(:new2).returns(conn)
      
    RhnSatellite::ChannelAccess.username = 'user'
    RhnSatellite::ChannelAccess.password = 'pwd'
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
  end
  
  describe ".disable_user_restrictions" do
    it "disables the user restrictions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.access.disableUserRestrictions",
        "token",
        'some_channel').returns(1)

      RhnSatellite::ChannelAccess.disable_user_restrictions('some_channel').should eql(1)
    end
  end
  
  describe ".enable_user_restrictions" do
    it "enables the user restrictions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.access.enableUserRestrictions",
        "token",
        'some_channel').returns(1)

      RhnSatellite::ChannelAccess.enable_user_restrictions('some_channel').should eql(1)
    end
  end
  
  describe ".get_org_sharing" do
    it "returns the org sharing access" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.access.getOrgSharing",
        "token",
        'some_channel').returns('public')

      RhnSatellite::ChannelAccess.get_org_sharing('some_channel').should eql('public')
    end
  end
  describe ".set_org_sharing" do
    it "sets the org sharing access" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.access.setOrgSharing",
        "token",
        'some_channel',
        'public').returns(1)

      RhnSatellite::ChannelAccess.set_org_sharing('some_channel','public').should eql(1)
    end
  end
end
