module RhnSatellite
  module Connection
    class Base
      class << self
        attr_accessor :hostname, :username, :password
        attr_writer :timeout, :https

        attr_reader :collection_cmd
        
        def reset
          RhnSatellite::Connection::Handler.reset_instance(self.name)
        end

        def timeout
          @timeout ||= 30
        end

        def https
          @https.nil? ? (@https=true) : @https
        end

        private
        def base
          RhnSatellite::Connection::Handler.instance_for(self.name, hostname, username, password, timeout, https)
        end

        def collection(cmd)
          @collection_cmd = cmd 
          extend RhnSatellite::Common::Collection
        end
      end
    end
  end
end
