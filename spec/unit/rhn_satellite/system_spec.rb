#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::System do
  context "standard invocation" do
    before(:each) do
      RhnSatellite::Systemgroup.reset
      conn = Object.new
      conn.stubs(:call)
      
      XMLRPC::Client.stubs(:new2).returns(conn)
      
      RhnSatellite::System.username = 'user'
      RhnSatellite::System.password = 'pwd'
      RhnSatellite::Connection::Handler.any_instance.stubs(:make_call).with("auth.login",'user','pwd').returns("token")
      RhnSatellite::Connection::Handler.any_instance.stubs(:make_call).with("auth.logout",'token')
    end
    
    describe ".all" do
      it "logins and returns a bunch of systems" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns(["123","234"])
        
        RhnSatellite::System.all.should eql(["123","234"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns(nil)
        
        RhnSatellite::System.all.should eql([])      
      end
      
      it "iterates the items over the block" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns(["123","234"])
        RhnSatellite::System.all{|i| ["123","234"].include?(i).should be_true }.should eql(["123","234"])
      end
    end
    
    describe ".relevant_erratas" do
      it "logins and returns a bunch of activation keys" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").returns(["errata1","errata2"])
        
        RhnSatellite::System.relevant_erratas("1").should eql(["errata1","errata2"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").returns(nil)
        
        RhnSatellite::System.relevant_erratas("1").should eql([])      
      end
    end
    
    describe ".latest_upgradable_packages" do
      it "logins and returns a bunch of activation keys" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(["package1","package2"])
        
        RhnSatellite::System.latest_upgradable_packages("1").should eql(["package1","package2"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(nil)
        
        RhnSatellite::System.latest_upgradable_packages("1").should eql([])      
      end
    end
    
    describe ".uptodate?" do
      it "returns true if no packages are upgradeable and no erratas are available" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").returns(nil)
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(nil)
        
        RhnSatellite::System.uptodate?("1").should eql(true)
      end
      
      it "returns false if packages are upgradeable" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(['package2'])
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").never
        
        RhnSatellite::System.uptodate?("1").should eql(false)
      end

      it "returns false if erratas are available" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").returns(["errata2"])
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(nil)
        
        RhnSatellite::System.uptodate?("1").should eql(false)
      end

      it "returns false if erratas and packages are available" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getRelevantErrata',"token","1").never
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestUpgradablePackages',"token","1").returns(['package2'])
        
        RhnSatellite::System.uptodate?("1").should eql(false)
      end
    end
    
    describe ".active_systems" do
      it "logins and returns a bunch of activation keys" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listActiveSystems',"token").returns(["123","234"])
        
        RhnSatellite::System.active_systems.should eql(["123","234"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listActiveSystems',"token").returns(nil)
        
        RhnSatellite::System.active_systems.should eql([])      
      end
    end
    
    describe ".active?" do
      it "returns true if system is list of active systems" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listActiveSystems',"token").returns([{'name' => "123"},{'name' => "234"}])
        
        RhnSatellite::System.active?("123").should eql(true)
      end
      
      it "returns false if not in list" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listActiveSystems',"token").returns([{'name' => "123"},{'name' => "234"}])
        
        RhnSatellite::System.active?("1233").should eql(false)      
      end
      it "returns false if list is empty" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listActiveSystems',"token").returns(nil)
        
        RhnSatellite::System.active?("1233").should eql(false)      
      end
    end
    
    describe ".detail" do
      it "logins and returns details of a system" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getDetails',"token",1).returns("foo")
        
        RhnSatellite::System.details('1').should eql("foo")
      end
      
      it "returns nothing on an inexistant system" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getDetails',"token",1).returns(nil)
        
        RhnSatellite::System.details("1").should eql(nil)      
      end
    end
    
    describe ".online?" do
      it "should return true if the system is in the satellite and listed as active" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns([{'name' => "123", 'id' => "1"},{'name' => "234", "id" => "2"}])
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getDetails',"token",1).returns({"osa_status" => 'online'})
        
        RhnSatellite::System.online?('123').should be_true
      end
      
      it "should return false if the system is not active" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns([{'name' => "123", 'id' => "1"},{'name' => "234", "id" => "2"}])
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getDetails',"token",1).returns({"osa_status" => 'offline'})
        
        RhnSatellite::System.online?('123').should be_false
      end
      
      it "should return false if the system is not in the satellite" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns([{'name' => "123", 'id' => "1"},{'name' => "234", "id" => "2"}])
        RhnSatellite::System.online?('333123').should be_false
      end
    end
    
    describe ".get" do
      context "with systems" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns([{'name' => "123"},{'name' => "234"}])
        end
        it "finds a system in all systems" do
          RhnSatellite::System.get('123').should eql({'name' => '123'})
        end
        
        it "returns nil on an non-existant system" do
          RhnSatellite::System.get('12333').should eql(nil)
        end
      end
      context "without any systems" do
        before :each do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listUserSystems',"token").returns([])
        end
        it "returns nil" do
          RhnSatellite::System.get('12333').should eql(nil)
        end
      end
    end
  end
end