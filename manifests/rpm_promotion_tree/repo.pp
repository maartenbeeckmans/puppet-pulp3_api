define pulp3_api::rpm_promotion_tree::repo (
  String $distribution_prefix = '',
  String $environment = '',
  String $releasever = '8',
  String $basearch = 'x86_64',
  Integer $retain_package_versions = 0,
) {
  # Create repository
  $_repository_config = {
    'description'             => "${environment}-${name} managed by Puppet",
    'retain_package_versions' => $retain_package_versions,
  }
  ensure_resource( 'pulp3_rpm_repository', "${environment}-${name}", $_repository_config )

  # Create distribution
  $_distribution_config = {
    'base_path' => "${distribution_prefix}${environment}/${releasever}/${basearch}/${name}"
  }
  ensure_resource( 'pulp3_rpm_distribution', "${environment}-${name}", $_distribution_config )
}
