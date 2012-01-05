module RhnSatellite
  class Package < RhnSatellite::Connection::Base
    class << self
      def details(package_id)
        base.default_call('package.getDetails',package_id.to_i)
      end

      def exists?(package_id)
        !details(package_id).nil?
      rescue XMLRPC::FaultException
        false
      end
    end
  end
end
