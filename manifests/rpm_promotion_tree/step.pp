# rpm_promotion_tree step
# Steps: dev, uat, and prod
define pulp3_api::rpm_promotion_tree::step (
  Hash    $repositories,
  String  $project,
  String  $releasever,
  String  $basearch,
  String  $distribution_prefix,
  String  $first_target,
  Array   $next_targets = [],
  Boolean $archive      = false,
) {
  create_resources(pulp3_api::rpm_promotion_tree::repo,
    $repositories,
    {
      project             => $project,
      environment         => $title,
      releasever          => $releasever,
      basearch            => $basearch,
      distribution_prefix => $distribution_prefix,
    }
  )

  # Use $next_targets to create the script
  # For every next target create the script
  # promote-${current_step}-${next_step}
  #if $next_targets != [] {
  #  file { "/tmp/${first_target}${next_targets}":
  #    ensure => file,
  #  }
  #}

  # If first target
  # Create script that can be used to import from remote repositories
  #if $first_target == $title {
  #  file { "/tmp/${first_target}":
  #    ensure => file,
  #  }
  #}
}
