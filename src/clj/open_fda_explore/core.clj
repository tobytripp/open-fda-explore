(ns open-fda-explore.core
  (:use [datomic.api :only [q db] :as d])
  (:require [clojure.java.io :as io])
  (:gen-class :main true))

(def uri "datomic:mem://open-fda")
(def schema-path "resources/interaction-schema.edn")

(defn datomic-connection
  "Create a database at uri and return a connection"
  [uri]
  (d/create-database uri)
  (d/connect uri))

(defn load-data [path]
  (let [data (read-string (slurp path))
        conn (datomic-connection uri)]
    (println "Load schema…")
    @(d/transact conn (read-string (slurp schema-path)))
    (println "success!")
    (println "Load data…")
    @(d/transact conn data)
    (println "success!")
    conn
    ))

(defn -main
  "Application entry point"
  [& args]
  (println args)
  (if-let [path (first args)]
    (load-data path)
    (println "No data path given")))
