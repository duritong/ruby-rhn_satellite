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

    describe '.get_id' do
      before :each do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getId',"token",'sysname').returns({'name' => "sysname", 'id' => '123'})
      end
      it "finds a system id" do
        RhnSatellite::System.get_id('sysname').should eql({'name' => 'sysname', 'id' => '123'})
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

    describe ".newer_installed_packages" do
      it "logins and returns a bunch of packages" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listNewerInstalledPackages',"token","1","kernel","0","0","").returns(["package1","package2"])
        
        RhnSatellite::System.newer_installed_packages("1","kernel","0","0","").should eql(["package1","package2"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listNewerInstalledPackages',"token","1","noexist","0","0","").returns(nil)
        
        RhnSatellite::System.newer_installed_packages("1","noexist","0","0","").should eql([])      
      end
    end

    describe ".latest_installable_packages" do
      it "logins and returns a bunch of packages" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestInstallablePackages',"token","1").returns(["package1","package2"])
        
        RhnSatellite::System.latest_installable_packages("1").should eql(["package1","package2"])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestInstallablePackages',"token","1").returns(nil)
        
        RhnSatellite::System.latest_installable_packages("1").should eql([])      
      end
    end
    
    describe ".latest_available_packages" do
      it "logins and returns a bunch of packages per system" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestAvailablePackages',"token",["1",'2']).returns([['sys1','sysname1',"package1","package2"], ['sys2','sysname2','package3']])
        
        RhnSatellite::System.latest_available_packages(["1",'2']).should eql([['sys1','sysname1',"package1","package2"], ['sys2','sysname2','package3']])
      end
      
      it "returns an empty array on an empty answer" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listLatestAvailablePackages',"token",["1",'2']).returns(nil)
        
        RhnSatellite::System.latest_available_packages(["1",'2']).should eql([])      
      end
    end
    
    describe ".latest_upgradable_packages" do
      it "logins and returns a bunch of packages" do
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
    
    describe ".delete" do
      it "logs in and should delete a system ID" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.deleteSystems','token',[1]).returns(1)

        RhnSatellite::System.delete(1).should eql(1)
      end

      it "logs in and should delete multiple system IDs" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.deleteSystems','token',[1,2]).returns(1)

        RhnSatellite::System.delete([1,2]).should eql(1)
      end

      it "returns nothing on an inexistant system ID" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.deleteSystems',"token",[1233]).returns(nil)
        
        RhnSatellite::System.delete(1233).should eql(nil)
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

    describe ".set_base_channel" do
      it "should set the base channel" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.setBaseChannel','token',1,'channel').returns(1)

        RhnSatellite::System.set_base_channel('1','channel').should eql(1)
      end
    end

    describe ".subscribed_base_channel" do
      it "should get the subscribed base channel" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.getSubscribedBaseChannel','token',1).returns({ 'label' => 'some_channel' })

        RhnSatellite::System.subscribed_base_channel('1').should eql({ 'label' => 'some_channel' })
      end
    end
    describe ".subscribable_base_channels" do
      it "should get the subscribable base channels" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listSubscribableBaseChannels','token',1).returns([{ 'label' => 'some_channel' }])

        RhnSatellite::System.subscribable_base_channels('1').should eql([{ 'label' => 'some_channel' }])
      end
    end

    describe ".set_child_channels" do
      it "should set the child channels" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.setChildChannels','token',1,['channel1','channel2']).returns(1)

        RhnSatellite::System.set_child_channels('1',['channel1','channel2']).should eql(1)
      end
    end

    describe ".subscribed_child_channels" do
      it "lists all the subscribed child channels" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listSubscribedChildChannels','token',1).returns([{ 'label' => 'some_child_channel' }])

        RhnSatellite::System.subscribed_child_channels('1').should eql([{ 'label' => 'some_child_channel' }])
      end
    end
    describe ".subscribable_child_channels" do
      it "should get the subscribable child channels" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.listSubscribableChildChannels','token',1).returns([{ 'label' => 'some_child_channel' }])

        RhnSatellite::System.subscribable_child_channels('1').should eql([{ 'label' => 'some_child_channel' }])
      end
    end

    describe ".schedule_apply_errata" do
      it "should handle single ids correctly" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleApplyErrata','token',[1],[9]).returns(1)

        RhnSatellite::System.schedule_apply_errata(1,9).should eql(1)
      end
      context "immeditalely" do
        it "should schedule the list of errata immediately" do
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleApplyErrata','token',[1,2],[9,22]).returns(1)

          RhnSatellite::System.schedule_apply_errata([1,2],[9,22]).should eql(1)
        end
      end
      context "later" do
        it "should schedule the list of errata to a later point" do
          now = DateTime.now.to_s
          RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleApplyErrata','token',[1,2],[9,22],now).returns(1)

          RhnSatellite::System.schedule_apply_errata([1,2],[9,22],now).should eql(1)
        end
      end

    end
    describe ".schedule_reboot" do
      it "should schedule a reboot immediately by default" do
        now = Time.now
        Time.expects(:now).once.returns(now)
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleReboot','token',1,'foo').returns(1)
        RhnSatellite::System.schedule_reboot(1).should eql(1)
      end

      it "should schedule a reboot to a certain time" do
        later = DateTime.now+600
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleReboot','token',1,'foo').returns(1)
        RhnSatellite::System.schedule_reboot(1,later).should eql(1)

      end
    end

    describe ".schedule_package_install" do
      it "should schedule a package install immediately by default" do
        now = Time.now
        Time.expects(:now).once.returns(now)
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.schedulePackageInstall','token',1,[1,2],'foo').returns(1)
        RhnSatellite::System.schedule_package_install(1,[1,2]).should eql(1)
      end

      it "should schedule a package install to a certain time" do
        later = DateTime.now+600
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.schedulePackageInstall','token',1,[1,2],'foo').returns(1)
        RhnSatellite::System.schedule_package_install(1,[1,2],later).should eql(1)

      end
   end

    describe ".schedule_script_run" do
      it "should schedule a script run immediately by default" do
        now = Time.now
        Time.expects(:now).once.returns(now)
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleScriptRun','token',1,'user','group',5,'#!/bin/bash\necho "hello"','foo').returns(1)
        RhnSatellite::System.schedule_script_run(1,'user','group',5,'#!/bin/bash\necho "hello"').should eql(1)
      end

      it "should schedule a script run to a certain time" do
        later = DateTime.now+600
        XMLRPC::DateTime.expects(:new).once.returns('foo')
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with('system.scheduleScriptRun','token',[1,2],'user','group',5,'#!/bin/bash\necho "hello"','foo').returns(1)
        RhnSatellite::System.schedule_script_runs([1,2],'user','group',5,'#!/bin/bash\necho "hello"',later).should eql(1)

      end
    end
  end
end
