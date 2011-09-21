module RhnSatellite
  class System < RhnSatellite::Connection::Base
    collection 'system.listUserSystems'
    class << self

      def active_systems
        base.default_call('system.listActiveSystems').to_a
      end
      
      def details(system_id)
        base.default_call('system.getDetails',system_id.to_i)
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
        base.default_call('system.getRelevantErrata',system_id).to_a
      end
      
      def latest_upgradable_packages(system_id)
        base.default_call('system.listLatestUpgradablePackages',system_id).to_a
      end
      
      def uptodate?(system_id)
        latest_upgradable_packages(system_id).empty? && relevant_erratas(system_id).empty?
      end

      def subscribed_base_channel(system_id)
        base.default_call('system.getSubscribedBaseChannel',system_id.to_i)
      end
      def set_base_channel(system_id,channel_label)
        base.default_call('system.setBaseChannel',system_id.to_i,channel_label)
      end
      def subscribable_base_channels(system_id)
        base.default_call('system.listSubscribableBaseChannels',system_id.to_i)
      end

      def subscribed_child_channels(system_id)
        base.default_call('system.listSubscribedChildChannels',system_id.to_i)
      end
      def set_child_channels(system_id,child_channel_labels)
        base.default_call('system.setChildChannels',system_id.to_i,child_channel_labels)
      end
      def subscribable_child_channels(system_id)
        base.default_call('system.listSubscribableChildChannels',system_id.to_i)
      end

      def schedule_apply_errata(system_ids,errata_ids,earliest_occurence=nil)
        base.default_call(
          'system.scheduleApplyErrata',
          *([
              [*system_ids].collect{|i| i.to_i },
              [*errata_ids].collect{|i| i.to_i },
              RhnSatellite::Common::Misc.gen_date_time(earliest_occurence)
            ].compact))
      end

      def schedule_reboot(system_id,earliest_occurence='now')
        base.default_call('system.scheduleReboot',system_id.to_i,RhnSatellite::Common::Misc.gen_date_time(earliest_occurence))
      end

      def schedule_package_install(system_id,package_ids,earliest_occurence='now')
        base.default_call('system.schedulePackageInstall',system_id.to_i,package_ids,RhnSatellite::Common::Misc.gen_date_time(earliest_occurence))
      end
    end
  end
end
