#
# Defined type automatically generated
#
define pulp3_api::pulp3_rpm_repository (
    Optional[String] $description = undef,
    Optional[String] $metadata_signing_service = undef,
    Integer $retain_package_versions = 0,
) {
  pulp3_rpm_repository { $name:
    description => $description,
    metadata_signing_service => $metadata_signing_service,
    retain_package_versions => $retain_package_versions,
  }
}
