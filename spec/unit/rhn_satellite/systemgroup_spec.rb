#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Systemgroup do
  context "standard invocation" do
    before(:each) do
      RhnSatellite::Systemgroup.reset
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::Systemgroup.username = 'user'
      RhnSatellite::Systemgroup.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
    end
    
    describe ".all" do
      it "logins and returns a bunch of systemgroups" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listAllGroups',"token").returns(["123","234"])
        
        RhnSatellite::Systemgroup.all.should eql(["123","234"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listAllGroups',"token").returns(nil)
        
        RhnSatellite::Systemgroup.all.should eql([])      
      end
      
      it "iterates the items over the block" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listAllGroups',"token").returns(["123","234"])
        RhnSatellite::Systemgroup.all{|i| ["123","234"].include?(i).should be_true }.should eql(["123","234"])
      end
    end
    describe ".get" do
      context "with systems" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listAllGroups',"token").returns([{'name' => "123"},{'name' => "234"}])
        end
        it "finds a system in all systems" do
          RhnSatellite::Systemgroup.get('123').should eql({'name' => '123'})
        end

        it "returns nil on an non-existant system" do
          RhnSatellite::Systemgroup.get('12333').should eql(nil)
        end
      end
      context "without any systems" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listAllGroups',"token").returns([])
        end
        it "returns nil" do
          RhnSatellite::Systemgroup.get('12333').should eql(nil)
        end
      end
    end
    
    describe ".delete" do
      it "deletes on the api" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.delete',"token",'foogroup').returns(true)
        
        RhnSatellite::Systemgroup.delete('foogroup').should eql(true)
      end
    end
    
    describe ".create" do
      it "creates on the api" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.create',"token",'foogroup','somedesc').returns("foogroup")
        
        RhnSatellite::Systemgroup.create('foogroup','somedesc').should eql("foogroup")
      end
    end
    
    describe ".remove_systems" do
      it "removes systems from a group" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.addOrRemoveSystems',"token",'foogroup',['1','2'],false).returns(true)
        
        RhnSatellite::Systemgroup.remove_systems('foogroup',['1','2']).should eql(true)
      end
    end
    
    describe ".add_systems" do
      it "adds systems to a group" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.addOrRemoveSystems',"token",'foogroup',['1','2'],true).returns(true)
        
        RhnSatellite::Systemgroup.add_systems('foogroup',['1','2']).should eql(true)
      end
    end

    describe ".active_systems" do
      it "should list active systems in a group" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listActiveSystemsInGroup',"token",'foogroup').returns([1])
        
        RhnSatellite::Systemgroup.active_systems('foogroup').should eql([1])
      end
    end

    describe ".inactive_systems" do
      it "should list inactive systems in a group" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listInactiveSystemsInGroup',"token",'foogroup').returns([1])
        
        RhnSatellite::Systemgroup.inactive_systems('foogroup').should eql([1])
      end

      it "should list inactive systems in a group based on given days" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listInactiveSystemsInGroup',"token",'foogroup',7).returns([1])
        
        RhnSatellite::Systemgroup.inactive_systems('foogroup',7).should eql([1])
      end
    end
    
    [:systems, :systems_safe].each do |m|
      describe ".#{m.to_s}" do
        it "should list the systems" do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listSystems',"token",'foogroup').returns(["system2","system3"])
          
          RhnSatellite::Systemgroup.send(m,'foogroup').should eql(['system2','system3'])
        end
      end
    end
    
  end
  context "special invocation" do
    before(:each) do
      RhnSatellite::Systemgroup.reset
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::Systemgroup.username = 'user'
      RhnSatellite::Systemgroup.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('systemgroup.listSystems',"token",'emptygroup').raises XMLRPC::FaultException.new("500","foo") 
    end
    describe ".systems" do
      it "raises a XMLRPC::FaultException on an empty group" do
        lambda { RhnSatellite::Systemgroup.systems('emptygroup') }.should raise_error(XMLRPC::FaultException,'foo')
      end
    end
    describe ".systems_safe" do
      it "returns an empty array on an empty group" do
        RhnSatellite::Systemgroup.systems_safe('emptygroup').should eql([])
      end
    end
  end
end
