# 
# This type is automatically generated
#

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'test_pulp_rpm_repository',
  docs: <<-EOS,
@summary Serializer for Rpm Repositories.

This type provides Puppet with the capabilities to manage a pulp 
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      description: 'A unique name for this repository.',
      behavior: ':namevar',
    },
    description: {
      type: 'Optional[String]',
      description: 'An optional description.',
    },
    remote: {
      type: 'Optional[String]',
    },
    metadata_signing_service: {
      type: 'Optional[String]',
      description: 'A reference to an associated signing service.',
    },
    retain_package_versions: {
      type: 'Integer',
      description: 'The number of versions of each package to keep in the repository; older versions will be purged. The default is "0", which will disable this feature and keep all versions of each package.',
    },
    pulp_href: {
      type:       'String',
      desc:       'The Pulp href',
      behaviour:  :read_only,
    },
  },
)
