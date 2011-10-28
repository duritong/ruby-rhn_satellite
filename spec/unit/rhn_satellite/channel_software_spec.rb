#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::ChannelSoftware do
  before(:each) { RhnSatellite::ChannelSoftware.reset }
  
  describe ".clone" do
    before(:each) do
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::ChannelSoftware.username = 'user'
      RhnSatellite::ChannelSoftware.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    
    it "clones a channel" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.clone",
        "token",
        'old_channel',
        {
          'name' => 'new_channel',
          'label' => 'some_label',
          'summary' => 'summary'
        },
        true
      ).returns("123")

      RhnSatellite::ChannelSoftware.clone('old_channel','new_channel','some_label','summary')
    end
    context "with additional options" do
      it "should pass these options" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.clone",
        "token",
        'old_channel',
        {
          'name' => 'new_channel',
          'label' => 'some_label',
          'summary' => 'summary',
          'parent_label' => 'blub'
        },
        true
      ).returns("123")

      RhnSatellite::ChannelSoftware.clone('old_channel','new_channel','some_label','summary',true,'parent_label' => 'blub')        
      end
    end
  end
end
