;;;; cl-riak.lisp

(in-package #:cl-riak)

;;; "cl-riak" goes here. Hacks and glory await!
(setf drakma:*text-content-types* '(("text" . nil) ("application" . "json")))

(defun get (key &key bucket (server "localhost:8098"))
  (let ((request-url (concatenate 'string "http://" server "/riak/" (url-encode bucket :utf-8) "/" (url-encode key :utf-8))))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url)
      (let ((vclock (cdr (assoc :x-riak-vclock headers))))
	(when (= status 200) (values response vclock))))))

(defun mapred (mapreduce &key (server "localhost:8098"))
  (let ((request-url (concatenate 'string "http://" server "/mapred")))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url
			     :method :post
			     :content-type "application/json"
			     :content mapreduce)
      (when (= status 200) response))))

(defun delete (key &key bucket (server "localhost:8098"))
  (let ((request-url (concatenate 'string "http://" server "/riak/" (url-encode bucket :utf-8) "/" (url-encode key :utf-8))))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url
			     :method :delete)
      (cond ((or (= status 204) 
		 (= status 404)) t)
	    (t nil)))))

(defun set (key value &key bucket (server "localhost:8098") (content-type "text/plain") vclock)
  (let ((request-url (concatenate 'string "http://" server "/riak/" (url-encode bucket :utf-8) 
				  (when key (concatenate 'string "/" (url-encode key :utf-8))))))
    (multiple-value-bind (response status headers)
	(drakma:http-request request-url
			     :method (if key :put :post)
			     :content-type content-type
			     :content value
			     :parameters '(("returnbody" . "true"))
			     :additional-headers (when vclock '(("X-Riak-Vclock" . vclock))))
      (let* ((vclock (cdr (assoc :x-riak-vclock headers)))
	     (location (cdr (assoc :location headers)))
	     (key-name (lastcar (split-sequence #\/ location))))
	(cond ((= status 200) (values response vclock)) ; key = value
	      ((= status 201) (values key-name bucket)) ; key is nil; return the key name and the bucket
	      ((= status 204) t) ; "No Content". Used when returnbody is false
	      (t nil))))))
