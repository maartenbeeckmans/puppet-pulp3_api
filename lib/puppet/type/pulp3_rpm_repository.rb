# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulp3_rpm_repository',
  docs: <<-EOS,
@summary Resource for creating pulp3_rpm_repository

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
      type:      'String',
      desc:      'A unique name for this repository.',
      behaviour: :namevar,
    },
    description: {
      type:      'Optional[String]',
      desc:      'An optional description.',
    },
    metadata_signing_service: {
      type:      'Optional[String]',
      desc:      'A reference to an associated signing service.',
    },
    retain_package_versions: {
      type:      'Integer',
      desc:      'The number of versions of each package to keep in the repository; older versions will be purged. The default is "0", which will disable this feature and keep all versions of each package.',
      default: 0,
    },
    pulp_href: {
      type:      'String',
      desc:      'Pulp href',
      behaviour: :read_only,
    },
    pulp_created: {
      type:      'String',
      desc:      'Timestamp of creation.',
      behaviour: :read_only,
    },
    versions_href: {
      type:      'String',
      desc:      'Versions href',
      behaviour: :read_only,
    },
    latest_version_href: {
      type:      'String',
      desc:      'Latest version href',
      behaviour: :read_only,
    },
  },
)
