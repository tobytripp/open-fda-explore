(ns open-fda-explore.core
  (:require [clojure.java.io :as io]
            [clojure.pprint  :refer :all]
            [datomic.api     :only [q db] :as d]
            [environ.core    :refer [env]])
  (:gen-class :main true))

(def uri (env :db-uri))
(def schema-path (env :schema-path))

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

    (println "Load data…" path)

    ;; (doseq [d data]
    ;;   (pprint d)
    ;;   (pprint @(d/transact conn (list d))))
    @(d/transact conn data)
    (println "success!")
    conn
    ))

(defn female-reactions [db]
  (map #(let [reaction (d/entity db (first %))
              drug     (d/entity db (last  %))]
          {:drug     (:drug/product drug)
           :reaction (:reaction/reactionmeddrapt reaction)})

       (take 50
             (d/q '[:find ?reaction ?drug
                    :where
                    [?p :patient/gender :patient.gender/female]
                    [?reaction :reaction/patient ?p]
                    [?drug     :drug/patient ?p]]
                  db))))

(defn drugs-with-reaction [db reaction-name]
  (distinct
   (map #(:drug/product (d/entity db (first %)))
        (d/q '[:find ?drug
               :in $ ?reaction-name
               :where
               [?reaction :reaction/reactionmeddrapt ?reaction-name]
               [?reaction :reaction/patient ?p]
               [?drug     :drug/patient ?p]]
             db reaction-name))))

(defn drugs-sharing-reactions-with [db drug]
  (map #(d/entity db (first %))
       (d/q '[:find ?reaction-name
              :in $ ?drug-name
              :where
              [?reaction :reaction/reactionmeddrapt ?reaction-name]
              [?reaction :reaction/patient ?p]
              [?drug     :drug/patient ?p]
              [?drug     :drug/product ?drug-name]
              ]
            db drug)))


(defn -main
  "Application entry point"
  [& args]
  (if-let [path (first args)]
    (load-data path)
    (do
      (load-data (env :faers-path))
      (load-data (env :spl-path)))))
