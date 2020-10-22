define pulp3_api::rpm_promotion_tree (
  String $first_target,
  Hash   $targets,
  Hash   $repositories,
  String $releasever          = '8',
  String $basearch            = 'x86_64',
  String $project             = $title,
  String $distribution_prefix = 'private/environments/'
) {
  create_resources(pulp3_api::rpm_promotion_tree::step,
    $targets,
    {
      first_target        => $first_target,
      repositories        => $repositories,
      project             => $project,
      releasever          => $releasever,
      basearch            => $basearch,
      distribution_prefix => $distribution_prefix,
    }
  )
}
