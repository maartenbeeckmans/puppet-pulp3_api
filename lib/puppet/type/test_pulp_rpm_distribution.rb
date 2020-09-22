# 
# This type is automatically generated
#

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'test_pulp_rpm_distribution',
  docs: <<-EOS,
@summary Resource for creating test_pulp_rpm_distribution

This type provides Puppet with the capabilities to manage a pulp 
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    pulp_href: {
      type: 'String',
      desc: 'Pulp href',
    },
    pulp_created: {
      type: 'String',
      desc: 'Timestamp of creation.',
    },
    base_path: {
      type: 'String',
      desc: 'The base (relative) path component of the published url. Avoid paths that                     overlap with other distribution base paths (e.g. "foo" and "foo/bar")',
    },
    base_url: {
      type: 'String',
      desc: 'The URL for accessing the publication as defined by this distribution.',
    },
    content_guard: {
      type: 'Optional[String]',
      desc: 'An optional content-guard.',
    },
    name: {
      type: 'String',
      desc: 'A unique name. Ex, `rawhide` and `stable`.',
    },
    publication: {
      type: 'Optional[String]',
      desc: 'Publication to be served',
    },
  },
)
