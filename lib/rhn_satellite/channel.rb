require 'xmlrpc/client'
module RhnSatellite
  class Channel < RhnSatellite::Connection::Base
    collection 'channel.listSoftwareChannels'
  end
end