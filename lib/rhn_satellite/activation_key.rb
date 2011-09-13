require 'xmlrpc/client'
module RhnSatellite
    class ActivationKey < RhnSatellite::Connection::Base
        class << self
            def all(&blk)
                result = base.in_transaction(true) {|token| base.make_call('activationkey.listActivationKeys',token) }.to_a
                result.each {|record| yield(record) } if block_given?
                result
            end
        end
    end
end