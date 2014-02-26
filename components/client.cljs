(ns lighthouse-web.core
  (:use-macros [secretary.macros :only [defroute]])
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [goog.events :as events]
            [goog.Uri :as Uri]
            [ajax.core :refer [GET POST]]
            [cljs.core.async :as async :refer  [chan close! listen]]
            [goog.history.EventType :as history-event]
            [goog.history.Html5History :as Html5History]
            [secretary.core :as secretary]
            )
  )

; Utils
(enable-console-print!)
(defn system-guid [] (gensym "system"))
(defn now [] (js/Date.))

(def app-state
  (atom {:systems []
         :selected nil
         :view nil}))

(defn status-to-colour [status] (case status
                                  "ok" "green"
                                  "error" "red"
                                  "yellow"))

(defn system [system owner opts]
  "Component for the system entry in the sidebar"
  (om/component (dom/li #js {:className (str "repo " (status-to-colour (system :status)))}
                        (dom/a #js {:className "slug" :href (str "/" (system :id))} (system :name))
                        (dom/p #js {:className "summary"} (system :description)))))

(defn left [{:keys [systems]}]
  "Sidebar, contains the search interface and system switcher"
  (om/component (dom/div #js {:id "left"}
                         (dom/div #js {:id "search_box"}
                                  (dom/input #js {:placeholder "Search all..." :type "text"}))
                         (dom/div #js {:className "tab"}
                                  (dom/ul #js {:id "repos"} (om/build-all system systems))))))

(defn dashboard-view [{:keys [systems]}]
  "Dashboard of all systems"
  (om/component (dom/div #js {:id "main"} (dom/h1 nil "Dashboard"))))

(defn component-view [component owner]
  (om/component (dom/div #js {:className "component" }
                         (dom/h2 nil (component :name))
                         (dom/p nil (component :type)))))

(defn host-view [host owner]
  (om/component (dom/div #js {:className "component" }
                         (dom/h2 nil (host :hostname))
                         (dom/p nil (host :ip))
                         (apply dom/ul nil
                                (map (fn [component] (dom/li nil (component :name))) (host :components))))))

(defn system-view [{:keys [selected]}]
  "View one specific system"
  (om/component (dom/div #js {:id "main"}
                         (dom/h1 nil (selected :name))
                         (dom/p nil (selected :description))
                         (dom/div nil (om/build-all host-view (selected :hosts))))))

(defn layout [state owner opts]
  (om/component (dom/div #js {:className "application"}
                         (om/build top state)
                         (om/build left state)
                         (when (not (nil? (state :view))) (om/build (state :view) state)))))

(defroute "/" [] (swap! app-state assoc :view dashboard-view))

(defn find-system-by-slug [slug] (first (filter #(= (str (% :id)) slug) (@app-state :systems))))
(defroute "/:slug" {:keys [slug]} (swap! app-state assoc :view system-view :selected (find-system-by-slug slug)))

(om/root app-state layout (.getElementById js/document "wrapper"))

; Enable HTML5 History API
(def history (goog.history.Html5History.))
(.setUseFragment history false)
(.setPathPrefix history "")
(.setEnabled history true)

(events/listen js/document "click" (fn [e]
                                     (.preventDefault e)
                                     (when (= (.-nodeName (.-target e)) "A")
                                       (let [path (.getPath (.parse goog.Uri (.-href (.-target e))))]
                                         (when (secretary/any-matches? path)
                                           (. history (setToken path))
                                           (secretary/dispatch! path))
                                         (.preventDefault e)
                                         )
                                       )))

(defn initialize [services]
  (swap! app-state assoc :systems services)
  (secretary/dispatch! (. history (getToken))))

(defn fetch [] (GET "http://localhost:8080/services/" { :response-format :json :keywords? true :handler initialize}))

(def pusher (js/Pusher. "48576a45701f7987f3fc"))
(def channel (.subscribe pusher "updates"))
(.bind channel "service.create" fetch)
(.bind channel "service.update" fetch)
(.bind channel "service.destroy" fetch)

(fetch)
