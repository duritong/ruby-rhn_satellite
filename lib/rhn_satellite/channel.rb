module RhnSatellite
  class Channel < RhnSatellite::Connection::Base
    collection 'channel.listAllChannels'
  end
end
