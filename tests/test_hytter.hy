(import [hytter [hytter]])
(import os)
(import [requests-oauthlib [OAuth1]])

(defn test-config-existance []
  "Without a config file nothing will work"
  (assert (isinstance (hytter.load-auth-from-config) OAuth1)))

(defn test-default-user []
  "Without a config file nothing will work"
  (assert (not (none? (hytter.default-user)))))

(defn test-get-one-from-timeline []
  "Get a tweet from the timeline"
  (let [[oid (hytter.load-auth-from-config)]
        [default-user (hytter.default-user)]]
    (assert (= 
             (len (hytter.get-user-timeline oid default-user 1)) 
               1))))
