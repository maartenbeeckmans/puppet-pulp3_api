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
  Hash         $mirrors       = {},
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
  create_resources(pulp3_rpm_remote, $remotes)
  create_resources(pulp3_rpm_repository, $repositories)
  create_resources(pulp3_rpm_publication, $publications)
  create_resources(pulp3_rpm_distribution, $distributions)
  create_resources(pulp3_api::mirror, $mirrors)
}
