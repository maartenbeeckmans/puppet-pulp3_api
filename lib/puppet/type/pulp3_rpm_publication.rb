# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulp3_rpm_publication',
  docs: <<-EOS,
@summary Resource for creating pulp3_rpm_publication

This type provides Puppet with the capabilities to manage a pulp 
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    repository_version: {
      type:      'String',
      desc:      'Repository version',
      behaviour: :namevar,
    },
    repository: {
      type:      'String',
      desc:      'A URI of the repository to be published.',
    },
    metadata_checksum_type: {
      type:      'Enum[unknown, md5, sha1, sha224, sha256, sha384, sha512]',
      desc:      'The checksum type for metadata.',
      default:   'sha256',
    },
    package_checksum_type: {
      type:      'Enum[unknown, md5, sha1, sha224, sha256, sha384, sha512]',
      desc:      'The checksum type for packages.',
      default:   'sha256',
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
  },
)
