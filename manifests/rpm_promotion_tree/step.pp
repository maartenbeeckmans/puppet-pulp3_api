# rpm_promotion_tree step
# Steps: dev, uat, and prod
define pulp3_api::rpm_promotion_tree::step (
  Hash         $repositories,
  String       $project,
  String       $releasever,
  String       $basearch,
  String       $distribution_prefix,
  Stdlib::Fqdn $apihost                 = $::pulp3_api::apihost,
  Stdlib::Port $apiport                 = $::pulp3_api::apiport,
  Boolean      $first_target            = false,
  Optional[String]       $upstream         = undef,
  Integer      $retain_package_versions = 0,
  String       $environment             = $title,
) {
  create_resources(pulp3_api::rpm_promotion_tree::repo,
    prefix($repositories, "${project}-${environment}-${releasever}-${basearch}-"),
    {
      distribution_prefix     => "${distribution_prefix}${environment}/${releasever}/${basearch}",
      retain_package_versions => $retain_package_versions,
    }
  )
  if $first_target {
    # fetch from mirrors
    $_repositories = prefix($repositories, "${project}-${environment}-${releasever}-${basearch}-")
    $_promote_config_hash = {
      'apihost' => $apihost,
      'apiport' => $apiport,
      'repositories' => $_repositories,
    }
    file { "/usr/local/bin/promote-mirrors-${environment}.sh":
      ensure  => present,
      mode    => '0755',
      content => epp("${module_name}/sync_repos.sh.epp", $_promote_config_hash),
    }
  } else {
    # fetch from previous step
    $_repositories = prefix($repositories, "${project}-${environment}-${releasever}-${basearch}-")
    $_promote_config_hash = {
      'apihost'      => $apihost,
      'apiport'      => $apiport,
      'repositories' => $_repositories,
    }
    file { "/usr/local/bin/promote-${upstream}-${environment}.sh":
      ensure  => present,
      mode    => '0755',
      content => epp("${module_name}/sync_repos.sh.epp", $_promote_config_hash),
    }
  }
}
