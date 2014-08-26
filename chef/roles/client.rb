name "client"
description "Role for a datomic client in Clojure"

run_list(
  "recipe[leiningen]",
  "recipe[ruby_bundler]"
)
