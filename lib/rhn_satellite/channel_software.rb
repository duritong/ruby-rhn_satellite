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
    end
    
  end
end
