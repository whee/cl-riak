;;;; package.lisp

(defpackage #:cl-riak
  (:use #:cl)
  (:import-from #:drakma #:url-encode)
  (:shadow #:get #:set #:delete)
  (:export #:get #:set #:delete #:mapred))
