;;;; package.lisp

(defpackage #:cl-riak
  (:use #:cl)
  (:shadow #:get #:set #:delete)
  (:export #:get #:set #:delete))
