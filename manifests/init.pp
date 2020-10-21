#
#
#
class pulp3_api (
  String       $apiuser                = $::profile_pulp3::admin_username,
  String       $apipass                = $::profile_pulp3::admin_pass,
  Stdlib::Fqdn $apihost                = $::profile_pulp3::api_address,
  Stdlib::Port $apiport                = $::profile_pulp3::api_port,
  Hash         $rpm_remotes            = {},
  Hash         $rpm_repositories       = {},
  Hash         $rpm_publications       = {},
  Hash         $rpm_distributions      = {},
  Hash         $rpm_mirrors            = {},
  Hash         $rpm_promotion_defaults = {},
  Hash         $rpm_promotion_trees    = {},
)
{
  include ::resource_api

  # Api configuration file
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
  create_resources(pulp3_rpm_remote, $rpm_remotes)
  create_resources(pulp3_rpm_repository, $rpm_repositories)
  create_resources(pulp3_rpm_publication, $rpm_publications)
  create_resources(pulp3_rpm_distribution, $rpm_distributions)

  # Creating mirrors
  create_resources(pulp3_api::mirror, $rpm_mirrors)

  # Creating promotion trees
  create_resources(pulp3_api::rpm_promotion_tree, $rpm_promotion_trees, $rpm_promotion_defaults)
}
