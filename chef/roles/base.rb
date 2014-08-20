name "base"
description "Base role."

run_list( "recipe[java]" )

default_attributes(
  "java" => {
    "install_flavor" => "oracle",
    "jdk_version" => 7,
    "oracle" => {
      "accept_oracle_download_terms" => true
    }
  }
)
