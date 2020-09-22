# 
# This type is automatically generated
#

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'test_pulp_rpm_repository',
  docs: <<-EOS,
@summary Resource for creating test_pulp_rpm_repository

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
    versions_href: {
      type: 'String',
      desc: 'Versions href',
    },
    latest_version_href: {
      type: 'String',
      desc: 'Latest version href',
    },
    name: {
      type: 'String',
      desc: 'A unique name for this repository.',
    },
    description: {
      type: 'Optional[String]',
      desc: 'An optional description.',
    },
    metadata_signing_service: {
      type: 'Optional[String]',
      desc: 'A reference to an associated signing service.',
    },
    retain_package_versions: {
      type: 'Integer',
      desc: 'The number of versions of each package to keep in the repository; older versions will be purged. The default is "0", which will disable this feature and keep all versions of each package.',
      default: 0,
    },
  },
)
