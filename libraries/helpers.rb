#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

module MyFirewall
  module Helpers
    # Supported IP versions, there's only v4 and v6
    def my_firewall_supported_ip_versions
      %i(ipv4 ipv6)
    end

    # Create "extra options" string
    def my_firewall_extra_options(config)
      # if 'extra_options' is defined, use it directly overriding any other settings
      if config['extra_options']
        config['extra_options']
      else
        # build extra_options string
        options_string = ''
        options_string += "--dport #{config['dport']} " if config['dport']
        options_string += "--sport #{config['sport']} " if config['sport']
        options_string += "-m state --state #{config['state']} " if config['state']
        options_string
      end
    end

    def my_firewall_ip_version(config)
      if config['ip_version']
        # if ip_version is an arry, return it
        if config['ip_version'].is_a?(Array)
          config['ip_version']
        # Convert string to an array
        else
          [config['ip_version']]
        end
      # if ip_version is not set in a rule, default to
      else
        node['my_firewall']['ip_versions']
      end
    end
  end
end

Chef::Resource.send :include, MyFirewall::Helpers
