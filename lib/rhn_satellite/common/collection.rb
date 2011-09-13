module RhnSatellite
  module Common
    module Collection
      def all(&blk)
        result = base.in_transaction(true) {|token| base.make_call(@collection_cmd,token) }.to_a
        result.each {|record| yield(record) } if block_given?
        result
      end
    end
  end
end