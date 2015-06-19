;;;; 4chan.lisp

(in-package #:4chan)

(defparameter *chunk-size* 256
  "Files are downloaded in chunks of this many bytes.")

(defvar *thread-url*)

(defun get-file-name (url)
  (let ((path (pathname url))
	(dir (get-thread-title)))
    (concatenate 'string
		 dir
		 "/"
		 (pathname-name path)
		 "."
		 (pathname-type path))))

(defun get-thread-title ()
  (pathname-name (pathname *thread-url*)))

(defun create-dir ()
  (ensure-directories-exist (get-thread-title)))

(defun download-image (img-link)
  (let* ((url (prepare-link img-link)))
    (trivial-download:download url (get-file-name url))))

(defun prepare-link (href)
  (concatenate 'string "http://" (subseq href 2)))

(defun get-images (url)
  (setq *thread-url* url)
  (create-dir)
  (let* ((str (drakma:http-request url))
	 (document (chtml:parse str (cxml-stp:make-builder))))
    (stp:do-recursively (a document)
      (when (and (typep a 'stp:element)
		 (equal (stp:local-name a) "a")
		 (equal (stp:attribute-value a "class") "fileThumb"))	
	(download-image (stp:attribute-value a "href"))))))
