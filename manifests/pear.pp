# Add a define to allow installing PEAR packages.
define php54::pear(
  $package = $title,
  $repository = "pear.php.net",
  $version = "latest"
) {
  if $version != "latest" {
    $pear_source = "${repository}/${package}-${version}"
  } else {
    $pear_source = "${repository}/${package}"
  }

  package { "pear-${repository}-${package}":
    name => $package,
    provider => "pear",
    source => $pear_source,
    ensure => $version,
    require => Class["pear"],
  }
}
