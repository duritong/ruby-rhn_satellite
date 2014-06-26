require 'date'

require 'xmlrpc/client'
require 'rhn_satellite/common/misc'
require 'rhn_satellite/common/debug'
require 'rhn_satellite/connection/handler'
require 'rhn_satellite/connection/base'
require 'rhn_satellite/common/collection'

require 'rhn_satellite/activation_key'
require 'rhn_satellite/api'
require 'rhn_satellite/channel'
require 'rhn_satellite/channel_software'
require 'rhn_satellite/channel_access'
require 'rhn_satellite/schedule'
require 'rhn_satellite/system'
require 'rhn_satellite/systemgroup'
require 'rhn_satellite/packages'

if File.exists?(file=File.expand_path('~/.satellite.yaml')) || File.exists?(file='/etc/satellite.yaml')
  require 'yaml'
  global_options = YAML.load_file(file)
  RhnSatellite::Connection::Handler.default_hostname = global_options['hostname']
  RhnSatellite::Connection::Handler.default_username = global_options['username']
  RhnSatellite::Connection::Handler.default_password = global_options['password']
  RhnSatellite::Connection::Handler.default_timeout = global_options['timeout']
  RhnSatellite::Connection::Handler.default_https = global_options['https']
  RhnSatellite::Connection::Handler.default_https_verify = global_options['https_verify']
end
