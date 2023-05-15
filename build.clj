(ns build
  (:require [clojure.tools.build.api :as b]))

(def app 'fluree/core)
(def version "3.0.0-alpha2")
(def class-dir "target/classes")
(def basis (b/create-basis {:project "deps.edn"}))
(def uberjar (format "target/%s-%s-%s.jar" (namespace app) (name app) version))

(defn clean [_]
  (b/delete {:path "target"}))

(defn uber [_]
  (clean nil)
  (b/copy-dir {:src-dirs   ["src" "resources"]
               :target-dir class-dir})
  (b/compile-clj {:basis     basis
                  :src-dirs  ["src"]
                  :class-dir class-dir})
  (b/uber {:class-dir class-dir
           :uber-file uberjar
           :basis     basis
           :main      'fluree.core.server}))
