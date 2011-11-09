require 'xmlrpc/client'
module RhnSatellite
  class ChannelSoftware < RhnSatellite::Connection::Base
    
    class << self
      def clone(original_label,name,label,summary,original_state=true,additional_options = {})
        channel_details = {
          'name' => name,
          'label' => label,
          'summary' => summary
        }.merge(additional_options)
        base.default_call('channel.software.clone',original_label,channel_details,original_state)
      end

      def list_children(channel_label)
        base.default_call('channel.software.listChildren',channel_label)
      end
    end
    
  end
end
