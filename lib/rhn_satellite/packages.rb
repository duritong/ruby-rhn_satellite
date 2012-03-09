require 'xmlrpc/client'
module RhnSatellite
  class Packages < RhnSatellite::Connection::Base
    class << self
      def details(package_id)
        base.default_call('packages.getDetails',package_id.to_i)
      end

      def exists?(package_id)
        !details(package_id).nil?
      rescue XMLRPC::FaultException
        false
      end
    end
  end
end
