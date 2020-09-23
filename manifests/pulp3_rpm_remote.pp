#
# Defined type automatically generated
#
define pulp3_api::pulp3_rpm_remote (
    String $url = undef,
    Optional[String] $ca_cert = undef,
    Optional[String] $client_cert = undef,
    Optional[String] $client_key = undef,
    Boolean $tls_validation = false,
    Optional[String] $proxy_url = undef,
    Optional[String] $username = undef,
    Optional[String] $password = undef,
    Integer $download_concurrency = 1,
    Enum[immediate, on_demand, streamed] $policy = immediate,
    Optional[String] $sles_auth_token = undef,
) {
  pulp3_rpm_remote { $name:
    url => $url,
    ca_cert => $ca_cert,
    client_cert => $client_cert,
    client_key => $client_key,
    tls_validation => $tls_validation,
    proxy_url => $proxy_url,
    username => $username,
    password => $password,
    download_concurrency => $download_concurrency,
    policy => $policy,
    sles_auth_token => $sles_auth_token,
  }
}
