#
#
#
class pulp3_api (
  String       $apiuser = 'admin',
  String       $apipass = 'admin',
  Stdlib::Fqdn $apihost = $facts['networking']['fqdn'],
  Stdlib::Port $apiport = 24817,

  Hash         $remotes       = {},
  Hash         $repositories  = {},
  Hash         $publications  = {},
  Hash         $distributions = {},
)
{
  $_settings_hash = {
    'apiuser' => $apiuser,
    'apipass' => $apipass,
    'apihost' => $apihost,
    'apiport' => $apiport,
  }

  file { '/etc/pulpapi.yaml':
    ensure  => file,
    content => epp("${module_name}/pulpapi.yaml.epp", $_settings_hash),
  }

  # Creating resources
  create_resources(pulp3_api::pulp3_rpm_remote, $remotes)
  create_resources(pulp3_api::pulp3_rpm_repository, $remotes)
  create_resources(pulp3_api::pulp3_rpm_publication, $remotes)
  create_resources(pulp3_api::pulp3_rpm_distribution, $remotes)
}
