module RhnSatellite
  module Common
    module Collection
      def all(&blk)
        result = base.default_call(@collection_cmd).to_a
        result.each {|record| yield(record) } if block_given?
        result
      end

      def get(name)
        all.find{|item| item["name"] =~ /#{name}/ }
      end
    end
  end
end
