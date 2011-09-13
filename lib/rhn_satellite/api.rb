module RhnSatellite
  class Api < RhnSatellite::Connection::Base
    class << self
      def api_version(disconnect=true)
        @api_version ||= get_version('getVersion',disconnect)
      end
      
      def satellite_version(disconnect=true)
        @satellite_version ||= get_version('systemVersion',disconnect)
      end
      
      def test_connection(user=nil,pwd=nil)
        reset
        test_base = RhnSatellite::Connection::Handler.instance_for(self.name, hostname, user||username, pwd||password, https)
        test_base.connect
        result = test_base.login && test_base.logout
        test_base.disconnect
        result
      end
      
      def reset
        @api_version = @satellite_version = nil
        super
      end
      
      private
      
      def get_version(cmd,disconnect=true)
        base.connect unless base.connected?
        result = base.make_call("api.#{cmd}")
        base.disconnect if disconnect
        result
      end
    end
  end
end