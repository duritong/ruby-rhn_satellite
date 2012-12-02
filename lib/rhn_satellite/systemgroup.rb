module RhnSatellite
  class Systemgroup < RhnSatellite::Connection::Base
    collection 'systemgroup.listAllGroups'
    
    class << self
      def delete(group_name)
        base.default_call('systemgroup.delete',group_name)
      end
      
      def create(group_name, description)
        base.default_call('systemgroup.create',group_name,description)
      end
      
      def active_systems(group_name)
        base.default_call('systemgroup.listActiveSystemsInGroup',group_name)
      end

      def inactive_systems(group_name,days=nil)
        if days
          base.default_call('systemgroup.listInactiveSystemsInGroup',group_name,days.to_i)
        else
          base.default_call('systemgroup.listInactiveSystemsInGroup',group_name)
        end
      end
      
      def systems(group_name)
        base.default_call('systemgroup.listSystems',group_name)
      end
      
      # if group is not valid an XMLRPC::FaultException is raised
      def systems_safe(group_name)
        systems(group_name)
      rescue XMLRPC::FaultException
        []
      end
      
      def remove_systems(group_name,system_ids)
        base.default_call('systemgroup.addOrRemoveSystems',group_name,system_ids,false)
      end
      
      def add_systems(group_name,system_ids)
        base.default_call('systemgroup.addOrRemoveSystems',group_name,system_ids,true)
      end
    end
  end
end
