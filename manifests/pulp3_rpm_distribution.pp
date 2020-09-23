#
# Defined type automatically generated
#
define pulp3_api::pulp3_rpm_distribution (
    Optional[String] $content_guard = undef,
    String $name = undef,
    Optional[String] $publication = undef,
) {
  pulp3_rpm_distribution { $base_path:
    content_guard => $content_guard,
    name => $name,
    publication => $publication,
  }
}
