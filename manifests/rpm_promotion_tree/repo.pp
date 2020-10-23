#
#
#
define pulp3_api::rpm_promotion_tree::repo (
  String $distribution_prefix,
  String $project,
  String $environment,
  String $upstream = '',
  String $releasever = '8',
  String $basearch = 'x86_64',
  Integer $retain_package_versions = 0,
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
