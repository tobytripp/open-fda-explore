(defproject health-interactions "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure      "1.6.0"]
                 [com.datomic/datomic-free "0.9.4880.2"]
                 [environ                  "1.0.0"]]
  :main open-fda-explore.core
  :plugins [[lein-environ "1.0.0"]]
  :source-paths ["src/clj"]
  :jvm-opts     ["-Xmx1.75g"]
  :user {:plugins [[cider/cider-nrepl "0.8.1"]]}

  :repl-options {:init-ns open-fda-explore.core
                 :host    "0.0.0.0"
                 :port    4343}

  :profiles {:dev {:env {:faers-path  "resources/faers.edn"
                         :spl-path    "resources/spl.edn"
                         :schema-path "resources/interaction-schema.edn"
                         :db-uri      "datomic:mem://open-fda"}}
             :test {:env {:db-uri      "datomic:mem://open-fda-test"
                          :schema-path "resources/interaction-schema.edn"}}
             :repl {:plugins [[cider/cider-nrepl "0.8.1"]]}})
