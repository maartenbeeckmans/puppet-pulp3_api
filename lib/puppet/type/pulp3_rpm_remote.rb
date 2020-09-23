# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulp3_rpm_remote',
  docs: <<-EOS,
@summary Resource for creating pulp3_rpm_remote

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
      desc:      'A unique name for this remote.',
      behaviour: :namevar,
    },
    url: {
      type:      'String',
      desc:      'The URL of an external content source.',
    },
    ca_cert: {
      type:      'Optional[String]',
      desc:      'A string containing the PEM encoded CA certificate used to validate the server certificate presented by the remote server. All new line characters must be escaped.',
    },
    client_cert: {
      type:      'Optional[String]',
      desc:      'A string containing the PEM encoded client certificate used for authentication. All new line characters must be escaped.',
    },
    client_key: {
      type:      'Optional[String]',
      desc:      'A PEM encoded private key used for authentication.',
    },
    tls_validation: {
      type:      'Boolean',
      desc:      'If True, TLS peer validation must be performed.',
      default: false,
    },
    proxy_url: {
      type:      'Optional[String]',
      desc:      'The proxy URL. Format: scheme://user:password@host:port',
    },
    username: {
      type:      'Optional[String]',
      desc:      'The username to be used for authentication when syncing.',
    },
    password: {
      type:      'Optional[String]',
      desc:      'The password to be used for authentication when syncing.',
    },
    download_concurrency: {
      type:      'Integer',
      desc:      'Total number of simultaneous connections.',
      default: 1,
    },
    policy: {
      type:      'Enum[immediate, on_demand, streamed]',
      desc:      'The policy to use when downloading content. The possible values include: "immediate", "on_demand", and "streamed". "immediate" is the default.',
      default:   'immediate',
    },
    sles_auth_token: {
      type:      'Optional[String]',
      desc:      'Authentication token for SLES repositories.',
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
    pulp_last_updated: {
      type:      'String',
      desc:      'Timestamp of the most recent update of the remote.',
      behaviour: :read_only,
    },
  },
)
