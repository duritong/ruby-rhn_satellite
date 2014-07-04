#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Kickstart do
  context "standard invocation" do
    before(:each) do
      #RhnSatellite::Systemgroup.reset
      conn = Object.new
      conn.stubs(:call)

      XMLRPC::Client.stubs(:new2).returns(conn)

      RhnSatellite::Kickstart.username = 'user'
      RhnSatellite::Kickstart.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.stubs(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.stubs(:make_call).with("auth.logout",'token')
    end

    describe ".all" do
      it "logins and returns a bunch of systems" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.listKickstarts',"token").returns(["123","234"])

        RhnSatellite::Kickstart.all.should eql(["123","234"])
      end

      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.listKickstarts',"token").returns(nil)

        RhnSatellite::Kickstart.all.should eql([])
      end

      it "iterates the items over the block" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.listKickstarts',"token").returns(["123","234"])
        RhnSatellite::Kickstart.all{|i| ["123","234"].include?(i).should be_true }.should eql(["123","234"])
      end
    end

    describe ".get" do
      context "with kickstarts" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.listKickstarts',"token").returns([{'name' => "123"},{'name' => "234"}])
        end
        it "finds a kickstart in all kickstarts" do
          RhnSatellite::Kickstart.get('123').should eql({'name' => '123'})
        end

        it "returns nil on an non-existant kickstart" do
          RhnSatellite::Kickstart.get('12333').should eql(nil)
        end
      end
      context "without any kickstarts" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.listKickstarts',"token").returns([])
        end
        it "returns nil" do
          RhnSatellite::Kickstart.get('12333').should eql(nil)
        end
      end
    end

    describe ".import_raw_file" do

      it "imports kickstart file contents" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
          "kickstart.importRawFile",
          "token",
          'some_label',
          'none',
          'tree_label',
          'ks_content'
        ).returns("1")

        RhnSatellite::Kickstart.import_raw_file('some_label', 'none', 'tree_label', 'ks_content')
      end
    end

    describe ".delete" do
      it "logs in and should delete a kickstart label" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.deleteProfile','token', 'some_label').returns(1)

        RhnSatellite::Kickstart.delete('some_label').should eql(1)
      end

      it "returns nothing on an inexistant kickstart label" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('kickstart.deleteProfile','token', 'some_missing_label').returns(nil)

        RhnSatellite::Kickstart.delete('some_missing_label').should eql(nil)
      end
    end


  end
end
