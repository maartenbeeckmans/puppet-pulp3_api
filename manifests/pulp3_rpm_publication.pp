#
# Defined type automatically generated
#
define pulp3_api::pulp3_rpm_publication (
    String $repository = undef,
    Enum[unknown, md5, sha1, sha224, sha256, sha384, sha512] $metadata_checksum_type = sha256,
    Enum[unknown, md5, sha1, sha224, sha256, sha384, sha512] $package_checksum_type = sha256,
) {
  pulp3_rpm_publication { $repository_version:
    repository => $repository,
    metadata_checksum_type => $metadata_checksum_type,
    package_checksum_type => $package_checksum_type,
  }
}
