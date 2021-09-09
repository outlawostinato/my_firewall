#
# Cookbook:: my_firewall
# Recipe:: default
#
# Copyright:: 2021, qubitrenegade
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

extend MyFirewall::Helpers

iptables_packages 'install iptables'

node['my_firewall']['ip_versions'].each do |ip_version|
  iptables_service "iptables services #{ip_version}" do
    ip_version ip_version
    action :enable
  end
end

# Iterate through our different chains
node['my_firewall']['iptables'].each do |chain, options|
  iptables_chain chain do
    chain chain.upcase
    value options['chain']['value'] # required
    table options['chain']['table'] || :filter # optional
  end

  # Iterate through the list of rules in our different individual chains.
  options['rules'].each do |name, config|
    # Setting the line explicitly overrides all other options
    if config['line']
      iptables_rule name do
        line config['line']
        action :create
      end
    else
      # Iterate through our list of IP versions for each rule
      # i.e.: we create IPv4, IPv6, or both IPv4 and IPv6 rules.
      my_firewall_ip_version(config).each do |ip_version|
        # Create or open an IPTables rule resource for modification
        rule = edit_resource :iptables_rule, "#{name} #{ip_version}" do
          table         config['table'] || :filter # optional
          chain         chain.to_sym
          ip_version    ip_version # config['ip_version'].to_sym
          extra_options my_firewall_extra_options(config)
          comment       config['comment'] || name # default to name if we don't specify a comment
          action        :create
        end

        # Iterate through a list of acceptable and optional parameters
        %w(protocol match source destination target jump go_to
          in_interface out_interface fragment line_number comment
          file_mode source_template cookbook sensitive config_file
        ).each do |property|
          # modify our rule resource by "send"ing our property to our rule.
          rule.send(property, config[property]) if config[property]
        end
      end
    end
  end
end
