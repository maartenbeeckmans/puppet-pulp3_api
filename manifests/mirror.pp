# Create mirror
# A mirror can have multiple publications and distributions
define pulp3_api::mirror (
  Stdlib::HTTPUrl $url,
  String          $base_path,
  Stdlib::Fqdn    $apihost = $pulp3_api::apihost,
  Stdlib::Port    $apiport = $pulp3_api::apiport,
) {
  # Create remote
  pulp3_rpm_remote { "${name}-mirror":
    url => $url,
  }

  # Create repository
  pulp3_rpm_repository { "${name}-mirror":
    description => 'Puppet managed repository',
  }

  # Create distribution
  pulp3_rpm_distribution { "${name}-mirror":
    base_path => $base_path,
  }

  # Create 
  $_mirror_script_config = {
  'api_host'               => $apihost,
  'api_port'               => $apiport,
  'remote_name'            => "${name}-mirror",
  'mirror'                 => true,
  'repo_name'              => "${name}-mirror",
  'distribution_name'      => "${name}-mirror",
  'distribution_base_path' => $base_path,
  }

  file { "/usr/local/bin/sync_mirror_${name}.sh":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => epp("${module_name}/mirror-publish.sh.epp", $_mirror_script_config),
    notify  => Exec["Sync mirror ${name}"],
  }

  # Sync remote with repository, create publication and update distribution
  # Timeout is 0 because syncing a repository can take a long time
  exec { "Sync mirror ${name}":
    command     => "/bin/bash -c /usr/local/bin/sync_mirror_${name}.sh",
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
    subscribe   => [
      Pulp3_rpm_remote[$name],
      Pulp3_rpm_repository[$name],
      Pulp3_rpm_distribution[$name]
    ],
  }


}
