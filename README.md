my_firewall Cookbook
==============

The purpose of this cookbook is to provide an attribute driven interface to the IPTables cookbook (and later the firewalld/nftables cookbook/resource?)

Requirements
------------

### Platforms

- Debian/Ubuntu (tested)
- RHEL (targeted, untested)

### Cookbooks

- iptables

Attributes
----------

* `default['my_iptables']['ip_versions']` - Array of ip versions.  Acceptable inputs  `%i(ipv4 ipv6)`.  Defaults to `%i(ipv4)`.
* `default['my_iptables']['iptables']` - configuration of IPTables, refer to Usage below for detailed explanation.
* `default['my_iptables']['iptables'][<CHAIN NAME>]` - Name of the chain we are going to manage.
* `default['my_iptables']['iptables'][<CHAIN NAME>]['chain']` - Chain configuration Options.  Requires a "value".
* `default['my_iptables']['iptables'][<CHAIN NAME>]['rules']` - Hash of rules.
* `default['my_iptables']['iptables'][<CHAIN NAME>]['rules']`

Recipes
-------

## default

The Default recipe dynamically creates `iptables_service`, `iptables_chain`, and `iptables_rule` resources based on the attributes set.

Usage
-----

The top most level is the Chain name, you can use the default chains or create your own.  By default, this cookbook manages `INPUT`, `FORWARD`, and `OUTPUT` rules.

Therefore, all of the `INPUT` rules will be managed under: `default['my_iptables']['iptables']['INPUT'] = {}`

All chain options are collected under `default['my_iptables']['iptables'][<CHAIN NAME>]['chain']`, and a `value` is always required.  This sets the default ACCEPT or DENY policy.  And will generally follow the form (refer to the iptables man page for specifics):

Allow All

```ruby
default['my_firewall']['iptables']['INPUT']['chain'] = {
  'value': 'ACCEPT [0:0]',
}
```

Deny All

```ruby
default['my_firewall']['iptables']['INPUT']['chain'] = {
  'value': 'DROP [0:0]',
}
```


Rules are arranged in the default['my_iptables']['iptables'][<CHAIN NAME>]['chain'] hash and follow the form:

```ruby
<Rule Name>: {
  **<Rule Options>
}
```

For example, an "Allow SSH" rule, might be written as:

```ruby
  'Allow SSH': {
    'protocol': 'tcp',
    'dport': '22',
    'state': 'NEW,ESTABLISHED',
    'jump': 'ACCEPT',
  }
```

Note that the name will be added as a comment if no comment parameter is specified.

Refer to the default attributes for a full demonstration.
