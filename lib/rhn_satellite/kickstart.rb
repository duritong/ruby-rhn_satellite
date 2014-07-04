module RhnSatellite
  class Kickstart < RhnSatellite::Connection::Base
    collection 'kickstart.listKickstarts'
    class << self
      def import_raw_file(profile_label, virtualization_type,
                      kickstartable_tree_label, kickstart_file_contents)

        base.default_call('kickstart.importRawFile', profile_label,
                          virtualization_type, kickstartable_tree_label,
                          kickstart_file_contents)
      end

      def delete(ks_label)
        base.default_call('kickstart.deleteProfile', ks_label)
      end
    end
  end
end
