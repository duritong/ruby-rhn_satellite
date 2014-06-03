
#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::Schedule do
  before(:each) do
    RhnSatellite::Schedule.reset
    conn = Object.new
    conn.stubs(:call)

    XMLRPC::Client.stubs(:new2).returns(conn)

    RhnSatellite::Schedule.username = 'user'
    RhnSatellite::Schedule.password = 'pwd'
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
  end

  describe ".archive_actions" do
    it "should archive actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.archiveActions",'token',[1,2]).returns(1)

      RhnSatellite::Schedule.archive_actions([1,2]).should eql(1)
    end
  end
  describe ".cancel_actions" do
    it "should cancel actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.cancelActions",'token',[1,2]).returns(1)

      RhnSatellite::Schedule.cancel_actions([1,2]).should eql(1)
    end
  end
  describe ".reschedule_actions" do
    it "should reschedule actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.rescheduleActions",'token',[1,2], true).returns(1)

      RhnSatellite::Schedule.reschedule_actions([1,2], true).should eql(1)
    end
  end
  describe ".delete_actions" do
    it "should delete actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.deleteActions",'token',[1,2]).returns(1)

      RhnSatellite::Schedule.delete_actions([1,2]).should eql(1)
    end
  end
  describe ".list_all_actions" do
    it "should list all the actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listAllActions",'token').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])

      RhnSatellite::Schedule.list_all_actions.should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])
    end
  end
  describe ".list_archived_actions" do
    it "should list all the archived actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listArchivedActions",'token').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'type'  => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])

      RhnSatellite::Schedule.list_archived_actions.should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])
    end
  end
  describe ".list_completed_actions" do
    it "should list all the completed actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listCompletedActions",'token').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'type'  => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])

      RhnSatellite::Schedule.list_completed_actions.should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])
    end
  end
  describe ".list_failed_actions" do
    it "should list all the failed actions" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listFailedActions",'token').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'type'  => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])

      RhnSatellite::Schedule.list_failed_actions.should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])
    end
  end
  describe ".list_in_progress_actions" do
    it "should list all the actions in progress" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listInProgressActions",'token').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'type'  => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])

      RhnSatellite::Schedule.list_in_progress_actions.should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'type' => 'type1',
          'scheduler' => 'user1',
          'earliest' => 1234,
          'completedSystems' => 1,
          'failedSystems' => 2,
          'inProgressSystems' => 0,
        },
        {
          'id' => 2,
          'name' => 'name2',
          'type' => 'type2',
          'scheduler' => 'user2',
          'earliest' => 1235,
          'completedSystems' => 2,
          'failedSystems' => 3,
          'inProgressSystems' => 1,
        }
      ])
    end
  end
  describe ".list_completed_systems" do
    it "should list all the completed systems" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listCompletedSystems",'token','1').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])

      RhnSatellite::Schedule.list_completed_systems('1').should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])
    end
  end
  describe ".list_failed_systems" do
    it "should list all the completed systems" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listFailedSystems",'token','1').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])

      RhnSatellite::Schedule.list_failed_systems('1').should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])
    end
  end
  describe ".list_in_progress_systems" do
    it "should list all the completed systems" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("schedule.listInProgressSystems",'token','1').returns([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])

      RhnSatellite::Schedule.list_in_progress_systems('1').should eql([
        {
          'id' => 1,
          'name' => 'name1',
          'base_channel'  => 'channel1',
          'timestamp' => 1234,
          'message' => '',
        },
        {
          'id' => 2,
          'name' => 'name2',
          'base_channel'  => 'channel2',
          'timestamp' => 1234,
          'message' => '',
        }
      ])
    end
  end
end
