default['my_firewall'] = {
  # uncomment this for IPv4 and IPv6
  # 'ip_versions': %i(ipv4 ipv6),
  'ip_versions': %i(ipv4),
  'iptables': {
    'INPUT': {
      'chain': {
        # Uncomment this to set default inbound rule to DROP all traffic,
        # this is the secure setting
        # 'value': 'DROP [0:0]',
        # This is the insecure setting
        'value': 'ACCEPT [0:0]',
      },
      'rules': {
        'Allow Loopback': {
          'in_interface': 'lo',
          'jump': 'ACCEPT',
        },
        'Allow SSH': {
          'protocol': 'tcp',
          'dport': '22',
          'state': 'NEW,ESTABLISHED',
          'jump': 'ACCEPT',
        },
        'Allow Initiated Connections': {
          'state': 'RELATED,ESTABLISHED',
          'jump': 'ACCEPT',
        },
      },
    },
    'FORWARD': {
      'chain': {
        'value': 'ACCEPT [0:0]',
      },
      'rules': {
      },
    },
    'OUTPUT': {
      'chain': {
        'value': 'ACCEPT [0:0]',
      },
      'rules': {
      },
    },
  },
}
