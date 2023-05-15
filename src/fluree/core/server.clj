(ns fluree.core.server
  (:require [fluree.http-api.system :as api])
  (:gen-class))

(defn -main
  [& args]
  (api/run-server {}))
