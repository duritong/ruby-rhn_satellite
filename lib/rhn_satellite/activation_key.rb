require 'xmlrpc/client'
module RhnSatellite
  class ActivationKey < RhnSatellite::Connection::Base
    collection 'activationkey.listActivationKeys'
  end
end
