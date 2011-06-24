;;;; cl-riak.asd

(asdf:defsystem #:cl-riak
  :serial t
  :depends-on (#:drakma
               #:alexandria)
  :components ((:file "package")
               (:file "cl-riak")))

