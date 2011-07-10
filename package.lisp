;;;; package.lisp

(defpackage #:cl-riak
  (:use #:cl #:split-sequence #:alexandria)
  (:import-from #:drakma #:url-encode)
  (:shadow #:get #:set #:delete)
  (:export #:get #:set #:delete #:mapred))
