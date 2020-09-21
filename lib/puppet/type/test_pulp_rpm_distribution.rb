# 
# This type is automatically generated
#

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'test_pulp_rpm_distribution',
  docs: <<-EOS,
@summary Serializer for RPM Distributions.

This type provides Puppet with the capabilities to manage a pulp 
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    base_path: {
      type: 'String',
      description: 'The base (relative) path component of the published url. Avoid paths that                     overlap with other distribution base paths (e.g. "foo" and "foo/bar")',
    },
    content_guard: {
      type: 'Optional[String]',
      description: 'An optional content-guard.',
    },
    name: {
      type: 'String',
      description: 'A unique name. Ex, `rawhide` and `stable`.',
      behavior: ':namevar',
    },
    publication: {
      type: 'Optional[String]',
      description: 'Publication to be served',
    },
    pulp_href: {
      type:       'String',
      desc:       'The Pulp href',
      behaviour:  :read_only,
    },
  },
)
