(ns open-fda-explore.core
  (:use [datomic.api :only [q bd] :as d]))

(def uri "datomic:mem://open-fda")

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))
