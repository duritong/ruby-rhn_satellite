require 'xmlrpc/client'
module RhnSatellite
  class Systemgroup < RhnSatellite::Connection::Base
    collection 'systemgroup.listAllGroups'
    
    class << self
      def delete(group_name)
        base.in_transaction(true) {|token| base.make_call('systemgroup.delete',token,group_name) }
      end
      
      def create(group_name, description)
        base.in_transaction(true){|token| base.make_call('systemgroup.create',token,group_name,description) }
      end
      
      def systems(group_name)
        base.in_transaction(true) {|token| base.make_call('systemgroup.listSystems',token,group_name) }
      end
      
      # if group is not valid an XMLRPC::FaultException is raised
      def systems_safe(group_name)
        systems(group_name)
      rescue XMLRPC::FaultException
        []
      end
      
      def remove_systems(group_name,system_ids)
        base.in_transaction(true) {|token| base.make_call('systemgroup.addOrRemoveSystems',token,group_name,system_ids,false) }
      end
      
      def add_systems(group_name,system_ids)
        base.in_transaction(true) {|token| base.make_call('systemgroup.addOrRemoveSystems',token,group_name,system_ids,true) }
      end
    end
  end
end