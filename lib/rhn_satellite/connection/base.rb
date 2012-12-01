module RhnSatellite
  module Connection
    class Base
      class << self
        attr_accessor :hostname, :username, :password, :timeout, :https

        attr_reader :collection_cmd
        
        def reset
          RhnSatellite::Connection::Handler.reset_instance(self.name)
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
