# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulp3_rpm_remote',
  docs: <<-EOS,
@summary a pulp3_rpm_remote type
@example
pulp3_rpm_remote { 'centos-8-appstream':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage ...
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
    url: {
      type:       'String',
      desc:       'The URL of an external content source.',
    },
    pulp_href: {
      type:       'String',
      desc:       'The Pulp href',
      behaviour:  :read_only,
    },
  },
)
