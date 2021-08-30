default['my_firewall'] = {
  'ip_versions': %i(ipv4 ipv6),
  'iptables': {
    'INPUT': {
      'chain': {
        # 'value': 'DROP [0:0]',
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
