module RhnSatellite
  module Common
    module Misc
      def gen_date_time(time='now')
        if time == 'now'
          t = Time.now
        elsif time.is_a?(DateTime) || time.is_a?(Time)
          t = time
        else
          return time
        end
        XMLRPC::DateTime.new(
          t.year,
          t.month,
          t.day,
          t.hour,
          t.min,
          t.sec
        )
      end
      module_function :gen_date_time
    end
  end
end
