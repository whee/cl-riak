;;;; cl-riak.asd

(asdf:defsystem #:cl-riak
  :serial t
  :depends-on (#:drakma
               #:alexandria
	       #:split-sequence)
  :components ((:file "package")
               (:file "cl-riak")))

