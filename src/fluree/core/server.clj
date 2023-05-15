(ns fluree.core.server
  (:require [fluree.http-api.system :as api])
  (:gen-class))

(defn -main
  [& args]
  (if-let [profile (some-> args first keyword)]
    (api/run-server {:profile profile})
    (api/run-server {})))
