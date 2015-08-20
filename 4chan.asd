;;;; 4chan.asd

(asdf:defsystem #:4chan
  :description "Download 4chan thread images"
  :author "Humberto Pinheiro <humbhenri@gmail.com>"
  :license "Public Domain"
  :depends-on (#:drakma #:closure-html #:cxml-stp #:trivial-download #:pb)
  :serial t
  :components ((:file "package")
               (:file "4chan")))

