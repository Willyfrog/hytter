;; Hy twitter timeline
;; Guillermo Vaya

(import [requests])
(import [requests-oauthlib [OAuth1]])
(import [ConfigParser [ConfigParser]])
(setv *base-url* "https://api.twitter.com/1.1/")
(setv *status-url* (.format "{base}statuses/" %base *base-url*))
(setv *search-url* (.format "{base}search/" %base *base-url*))
(setv *direct-messages-url* (.format "{base}direct_messages/" %base *base-url*))


;;   "Get oauth's identification given a token and an app key"
(defn oauth-identify
  [consumer-key consumer-secret token token-secret]
  (OAuth1 %client-key consumer-key
          %client-secret consumer-secret
          %resource-owner-key token
          %resource-owner-secret token-secret))

(defn get-twitter-action [action-url oauth]
  (requests.get %url action-url %auth oauth))

;;   "Get an user's timeline given its handle and oauth authentication"
(defn get-user-timeline 
  [oauth user &optional count since-id [include-rts true]]
  (let [[with-user (.format "&screen_name={user}" %user user)]
        [count-em (if (none? count) "" 
                      (.format "&count={count}" %count count))]
        [with-rts (.format "&include-rts={rts}" %rts include-rts)]
        [since (if (none? since-id) ""
                   (.format "&since-id={since}" %since since-id))]]
    (get-twitter-action (.format "{base}/user_timeline.json?trim-user=true{user}{count}{rts}{since}" 
                                 %base *status-url*
                                 %user with-user
                                 %count count-em
                                 %rts with-rts
                                 %since since)
                        oauth)))

(defn get-user-mentions 
  [oauth user &optional count since-id]
  (let [[with-user (.format "&screen_name={user}" %user user)]
        [count-em (if (none? count) 
                    "" 
                    (.format "&count={count}" %count count))]
        [since (if (none? since-id) ""
                   (.format "&since-id={since}" %since since-id))]]
      (get-twitter-action (.format "{base}mentions_timeline.json?trim-user=true{user}{count}" 
                                   %base *status-url*
                                   %user with-user
                                   %count count-em
                                   %since since)
                          oauth)))

(defn load-auth-from-config [&optional [file "hytter.cnf"]]
  (let [[config (ConfigParser)]]
    (.read config file)
    (oauth-identify (.get config "auth" "consumer-key")
                    (.get config "auth" "consumer-secret")
                    (.get config "auth" "token")
                    (.get config "auth" "token-secret"))))

(defn default-user [&optional [file "hytter.cnf"]]
  (let [[config (ConfigParser)]]
    (.read config file)
    (.get config "defaults" "user")))

(defn process-response [response]
  (unless (none? response)
    (, (getattr response ))))
