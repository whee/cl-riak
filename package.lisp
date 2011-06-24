;;;; package.lisp

(defpackage #:cl-riak
  (:use #:cl)
  (:shadow #:get #:set)
  (:export #:get #:set))
