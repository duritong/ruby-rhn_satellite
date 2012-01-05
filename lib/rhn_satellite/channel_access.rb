module RhnSatellite
  class ChannelAccess < RhnSatellite::Connection::Base
    
    class << self
      def disable_user_restrictions(channel_label)
        base.default_call('channel.access.disableUserRestrictions',channel_label)
      end
      def enable_user_restrictions(channel_label)
        base.default_call('channel.access.enableUserRestrictions',channel_label)
      end
      def get_org_sharing(channel_label)
        base.default_call('channel.access.getOrgSharing',channel_label)
      end
      def set_org_sharing(channel_label,access)
        base.default_call('channel.access.setOrgSharing',channel_label,access)
      end
    end
    
  end
end
