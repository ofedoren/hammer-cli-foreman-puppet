module HammerCLIForemanPuppet
  module CommandExtensions
    class Host < HammerCLI::CommandExtensions
      output do |definition|
        definition.insert(:after, :location, HammerCLIForemanPuppet::Host::InfoCommand.output_definition.fields)
      end
    end

    class HostPuppetProxy < HammerCLI::CommandExtensions
      option_family(
        format: HammerCLI::Options::Normalizers::List.new,
        aliased_resource: 'puppet-class',
        description: 'Names/Ids of associated Puppet classes'
      ) do
        parent '--puppet-class-ids', 'PUPPET_CLASS_IDS', _('List of Puppet class ids'),
               attribute_name: :option_puppetclass_ids
        child '--puppet-classes', 'PUPPET_CLASS_NAMES', '',
              attribute_name: :option_puppetclass_names
      end
      option_family associate: 'puppet_proxy' do
        child '--puppet-proxy', 'PUPPET_PROXY_NAME', _('Name of Puppet proxy')
      end
      option_family associate: 'puppet_ca_proxy' do
        child '--puppet-ca-proxy', 'PUPPET_CA_PROXY_NAME', _('Name of Puppet CA proxy')
      end

      request_params do |params, command_object|
        if command_object.option_puppet_proxy
          params['host']['puppet_proxy_id'] ||= HammerCLIForemanPuppet::CommandExtensions::HostPuppetProxy.proxy_id(
            command_object.resolver, command_object.option_puppet_proxy
          )
        end
        if command_object.option_puppet_ca_proxy
          params['host']['puppet_ca_proxy_id'] ||= HammerCLIForemanPuppet::CommandExtensions::HostPuppetProxy.proxy_id(
            command_object.resolver, command_object.option_puppet_ca_proxy
          )
        end
      end

      def self.proxy_id(resolver, name)
        resolver.smart_proxy_id('option_name' => name)
      end
    end
  end
end
