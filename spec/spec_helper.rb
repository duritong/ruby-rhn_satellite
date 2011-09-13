require 'pathname'
dir = Pathname.new(__FILE__).parent
$LOAD_PATH.unshift(File.join(dir,'lib'))
require 'rhn_satellite'
gem 'rspec', '~> 2.5.0'
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end

def with_real_satellite(calzz,&blk)
    unless ENV['NO_REAL_SATELLITE'] == '1'
        config = (ENV['SATELLITE_YML'] || File.expand_path(File.join(File.dirname(__FILE__),'..','config','satellite.yml')))
        if File.exist?(config) && (yml = YAML::load(File.open(config))) && (yml['hostname'] && yml['username'] && yml['password'])
            yield(yml)
        else
            puts "No satellite data found."
        end
    end
end