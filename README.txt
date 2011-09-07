# Basic usage

## Set
(cl-riak:set key value :bucket "bucket-name")

* (cl-riak:set "foo" "bar" :bucket "nom") 

"bar"
"a85hYGBgzGDKBVIcypz/fvql33qYwZTImMfK8CHsznG+LAA="

## Get
(cl-riak:get key value :bucket "bucket-name")

(cl-riak:get "foo" :bucket "nom")

"bar"
"a85hYGBgzGDKBVIcypz/fvql33qYwZTImMfK8CHsznG+LAA="

## MapReduce
(yes, this is ugly)

An example:
(define-constant +mapred-reminders+ "{
    \"inputs\":\"reminder\",
    \"query\":[
	{
	    \"map\":{
		\"language\":\"javascript\",
		\"source\":\"function (v, k, a) {var data = Riak.mapValuesJson(v)[0]; if (data.username == '~a') {return [{'key':v.key, 'value':v.values[0].data}];} else {return [];}}\",
		\"keep\":true
	    }
	}
    ]
}" :test 'string=)

(let ((reminders (cl-riak:mapred (format nil +mapred-reminders+ username))))
     ...)
