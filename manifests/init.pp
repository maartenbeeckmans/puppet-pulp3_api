#
#
#
class pulp3_api (
  String       $apiuser = 'admin',
  String       $apipass = 'admin',
  Stdlib::Fqdn $apihost = $facts['networking']['fqdn'],
  Stdlib::Port $apiport = 24817,
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
}
