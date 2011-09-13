module RhnSatellite
  class System < RhnSatellite::Connection::Base
    collection 'system.listUserSystems'
    class << self
      def get(server_name)
        all.find{|system| system["name"] =~ /#{server_name}/ }
      end
      
      def active_systems
        base.in_transaction(true) {|token| base.make_call('system.listActiveSystems',token) }.to_a
      end
      
      def details(system_id)
        base.in_transaction(true) {|token| base.make_call('system.getDetails',token,system_id.to_i) }
      end
      
      def online?(server_name)
       !(system = get(server_name)).nil? && \
        !(sysdetails = details(system['id'])).nil? && \
          (sysdetails['osa_status'] == 'online')
      end
      
      def active?(server_name)
        active_systems.any?{|system| system["name"] =~ /#{server_name}$/ }
      end
      
      def relevant_erratas(system_id)
        base.in_transaction(true){|token| base.make_call('system.getRelevantErrata',token,system_id) }.to_a
      end
      
      def latest_upgradable_packages(system_id)
        base.in_transaction(true){|token| base.make_call('system.listLatestUpgradablePackages',token,system_id) }.to_a
      end
      
      def uptodate?(system_id)
        latest_upgradable_packages(system_id).empty? && relevant_erratas(system_id).empty?
      end
    end
  end
end