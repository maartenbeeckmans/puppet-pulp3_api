#
#
#
define pulp3_api::remotes (
  Enum[present, absent] $ensure = 'present',
  String                $url,
) {
  pulp3_rpm_remote { $name:
    ensure => $ensure,
    url    => $url,
  }
}
