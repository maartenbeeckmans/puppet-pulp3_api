# Create mirror
define pulp3_api::mirror (
  String       $apiuser = $pulp3_api::apiuser,
  String       $apipass = $pulp3_api::apipass,
  Stdlib::Fqdn $apihost = $pulp3_api::apihost,
  Stdlib::Port $apiport = $pulp3_api::apiport,
  Hash $remote = {},
  Hash $repository = {},
  Hash $publication = {},
  Hash $distribution = {},
  Optional[String] $remote_href = undef,
  Optional[String] $repository_href = undef,
  Optional[String] $repository_version = undef,
) {
  # Create remote
  ensure_resource(pulp3_rpm_remote, $name, $remote)

  # Create repository
  ensure_resource(pulp3_rpm_repository, $name, $repository)

  # Sync remote with repository
  if $repository_href and $remote_href{
    exec { "Sync ${name}":
      command     => "curl -s -L -X POST -H 'Content-Type: application/json' 'http://${apiuser}:${apipass}@${apihost}:${apiport}${repository_href}sync/' -d '{\"remote\": \"${remote_href}\", \"mirror\": \"True\"}' ",
      path        => '/usr/bin/',
      user        => 'root',
      logoutput   => true,
      refreshonly => true,
      require     => [
        Pulp3_rpm_remote[$name],
        Pulp3_rpm_repository[$name]
      ],
    }
  }
  # Create publication
  if $repository_version {
    ensure_resource(pulp3_rpm_publication, $repository_version, $publication)
  }

  # Create distribution
  ensure_resource(pulp3_rpm_distribution, $name, $distribution)

}
