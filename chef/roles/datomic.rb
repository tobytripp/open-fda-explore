name "datomic"
description "Role for Datomic nodes."

run_list( "recipe[datomic]" )

default_attributes(
  "datomic" => {
    "version"  => "0.9.4880.2",
    # shasum -a 256 f
    "checksum" => "3a2a4e34a8dfb6f170e1a78a3121b17eee1b81c1705ae83045927b57b41ad7ea",

    "host"     => "33.33.33.10.xip.io",
    "port"     => 4334,
    "protocol" => "dev",
  }
)
