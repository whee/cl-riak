;;;; cl-riak.lisp

(in-package #:cl-riak)

;;; "cl-riak" goes here. Hacks and glory await!

(defun get (key &key bucket (server "localhost:8098"))
  (let ((request-url (concatenate 'string "http://" server "/riak/" bucket "/" key)))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url)
      (let ((vclock (cdr (assoc :x-riak-vclock headers))))
	(when (= status 200) (values response vclock))))))

(defun set (key value &key bucket (server "localhost:8098") (content-type "text/plain") vclock)
  (let ((request-url (concatenate 'string "http://" server "/riak/" bucket "/" key)))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url
			     :method :put
			     :content-type content-type
			     :content value
			     :parameters '(("returnbody" . "true"))
			     :additional-headers (when vclock '(("X-Riak-Vclock" . vclock))))
      (let ((vclock (cdr (assoc :x-riak-vclock headers))))
	(cond ((= status 200) (values response vclock))
	      ((= status 204) t) ; "No Content". Used when returnbody is false
	      (t nil))))))
