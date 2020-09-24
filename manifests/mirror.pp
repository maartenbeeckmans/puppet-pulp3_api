# Create mirror
# A mirror can have multiple publications and distributions
define pulp3_api::mirror (
  Stdlib::Fqdn $apihost = $pulp3_api::apihost,
  Stdlib::Port $apiport = $pulp3_api::apiport,
  Hash $remote = {},
  Hash $repository = {},
  Hash $publications = {},
  Hash $distributions = {},
  Optional[String] $remote_href = undef,
  Optional[String] $repository_href = undef,
  Optional[String] $repository_version = undef,
) {
  # Create remote
  ensure_resource(pulp3_rpm_remote, $name, $remote)

  # Create repository
  ensure_resource(pulp3_rpm_repository, $name, $repository)

  # Create 
  $_mirror_script_config = {
  'api_host'        => $apihost,
  'api_port'        => $apiport,
  'remote_name'     => $name,
  'repository_name' => $name,
  }

  file { "/usr/local/bin/sync_mirror_${name}.sh":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => epp("${module_name}/sync_repository.sh.epp", $_mirror_script_config),
    notify  => Exec["Sync mirror ${name}"],
  }

  # Sync remote with repository
  # Timeout is 0 because syncing a repository can take a long time
  # Syncing is part of the script because the repository must be synced before the publication can be created.
  exec { "Sync mirror ${name}":
    command     => "/bin/bash -c /usr/local/bin/sync_mirror_${name}.sh",
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
    subscribe   => [
      Pulp3_rpm_remote[$name],
      Pulp3_rpm_repository[$name]
    ],
    notify      => Pulp3_rpm_publication[$repository_version],
  }

  # Create publication
  #@TODO repository version: Latest or integer

  if $repository_version {
    ensure_resource(pulp3_rpm_publication, $repository_version, $publications)
  }

  # Create distribution
  ensure_resource(pulp3_rpm_distribution, $name, $distributions)

}
