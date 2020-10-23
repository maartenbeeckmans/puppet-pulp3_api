#
#
#
define pulp3_api::rpm_promotion_tree::repo (
  String  $distribution_prefix,
  Integer $retain_package_versions,
  Boolean $first_target            = false,
  String  $mirror                  = undef,
  String  $previous_target         = undef,
) {
  # Create repository
  $_repository_config = {
    'description'             => "${title} managed by Puppet",
    'retain_package_versions' => $retain_package_versions,
  }
  ensure_resource( 'pulp3_rpm_repository', $title, $_repository_config )

  # Create distribution
  $repo = split($title, '-')
  $_distribution_config = {
    'base_path' => "${distribution_prefix}/${repo[-1]}"
  }
  ensure_resource( 'pulp3_rpm_distribution', $title, $_distribution_config )
}
