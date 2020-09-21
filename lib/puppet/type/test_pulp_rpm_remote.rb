# 
# This type is automatically generated
#

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'test_pulp_rpm_remote',
  docs: <<-EOS,
@summary A Serializer for RpmRemote.

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
      description: 'A unique name for this remote.',
      behavior: ':namevar',
    },
    url: {
      type: 'String',
      description: 'The URL of an external content source.',
    },
    ca_cert: {
      type: 'Optional[String]',
      description: 'A PEM encoded CA certificate used to validate the server certificate presented by the remote server.',
    },
    client_cert: {
      type: 'Optional[String]',
      description: 'A PEM encoded client certificate used for authentication.',
    },
    client_key: {
      type: 'Optional[String]',
      description: 'A PEM encoded private key used for authentication.',
    },
    tls_validation: {
      type: 'Boolean',
      description: 'If True, TLS peer validation must be performed.',
    },
    proxy_url: {
      type: 'Optional[String]',
      description: 'The proxy URL. Format: scheme://user:password@host:port',
    },
    username: {
      type: 'Optional[String]',
      description: 'The username to be used for authentication when syncing.',
    },
    password: {
      type: 'Optional[String]',
      description: 'The password to be used for authentication when syncing.',
    },
    download_concurrency: {
      type: 'Integer',
      description: 'Total number of simultaneous connections.',
    },
    policy: {
      type: 'Enum["immediate", "on_demand", "streamed"]',
      description: 'The policy to use when downloading content. The possible values include: "immediate", "on_demand", and "streamed". "immediate" is the default.',
      default: 'immediate',
    },
    sles_auth_token: {
      type: 'Optional[String]',
      description: 'Authentication token for SLES repositories.',
    },
    pulp_href: {
      type:       'String',
      desc:       'The Pulp href',
      behaviour:  :read_only,
    },
  },
)
