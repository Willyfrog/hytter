(import [hytter :as ht])
(import os)
(import [requests-oauthlib [OAuth1]])

(defn test-config-existance []
  "Without a config file nothing will work"
  (assert (isinstance (ht.load-auth-from-config) OAuth1)))

(defn test-default-user []
  "Without a config file nothing will work"
  (assert (not (none? (ht.default-user)))))

(defn test-get-one-from-timeline []
  "Get a tweet from the timeline"
  (let [[oid (ht.load-auth-from-config)]
        [default-user (ht.default-user)]]
    (len
     (ht.get-user-timeline oid default-user 1) 1)))
