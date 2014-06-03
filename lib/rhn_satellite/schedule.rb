module RhnSatellite
  class Schedule < RhnSatellite::Connection::Base
    collection 'schedule.listAllActions'
    class << self

      def archive_actions(action_ids)
        base.default_call('schedule.archiveActions',action_ids)
      end

      def cancel_actions(action_ids)
        base.default_call('schedule.cancelActions',action_ids)
      end

      def delete_actions(action_ids)
        base.default_call('schedule.deleteActions',action_ids)
      end

      def list_all_actions
        base.default_call('schedule.listAllActions').to_a
      end

      def list_archived_actions
        base.default_call('schedule.listArchivedActions').to_a
      end

      def list_completed_actions
        base.default_call('schedule.listCompletedActions').to_a
      end

      def list_completed_systems(action_id)
        base.default_call('schedule.listCompletedSystems',action_id).to_a
      end

      def list_failed_actions
        base.default_call('schedule.listFailedActions').to_a
      end

      def list_failed_systems(action_id)
        base.default_call('schedule.listFailedSystems',action_id).to_a
      end

      def list_in_progress_actions
        base.default_call('schedule.listInProgressActions').to_a
      end

      def list_in_progress_systems(action_id)
        base.default_call('schedule.listInProgressSystems',action_id).to_a
      end

      def reschedule_actions(action_ids,only_failed)
        base.default_call('schedule.rescheduleActions',action_ids,only_failed)
      end
    end
  end
end
