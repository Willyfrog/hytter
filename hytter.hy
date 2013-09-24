;; Hy twitter timeline
;; Guillermo Vaya

(import [requests])
(import [requests-oauthlib [OAuth1]])

(setv twurl "https://api.twitter.com/1.1/statuses/mentions_timeline.json")

;;   "Get oauth's identification given a token and an app key"
(defn oauth-identify
  [consumer-key consumer-secret token token-secret]
  (OAuth1 %client-key consumer-key
          %client-secret consumer-secret
          %resource-owner-key token
          %resource-owner-secret token-secret))

(defn get-twitter-action [action-url oauth]
  (requests.get %url twurl %oauth oauth))

;;   "Get an user's timeline given its handle and oauth authentication"
(defn get-user-timeline 
  [oauth user] 
  (get-twitter-action (.format "https://api.twitter.com/1.1/statuses/mentions_timeline.json?screen_name={user}" user) oauth))


