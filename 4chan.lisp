;;;; 4chan.lisp

(in-package #:4chan)

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
    (with-open-stream (*standard-output* (make-broadcast-stream))
      (trivial-download:download url (get-file-name url)))))

(defun prepare-link (href)
  (concatenate 'string "http://" (subseq href 2)))

(defun image-p (stp-element)
  (and (typep stp-element 'stp:element)
       (equal (stp:local-name stp-element) "a")
       (equal (stp:attribute-value stp-element "class") "fileThumb")))


(defun get-images (url)
  (setq *thread-url* url)
  (create-dir)
  (let* ((body (drakma:http-request url))
	 (document (chtml:parse body (cxml-stp:make-builder)))
         (image-urls (list)))
    (stp:do-recursively (a document)
      (when (image-p a)
        (pushnew (stp:attribute-value a "href") image-urls :test 'equal)))
    (loop with total = (length image-urls)
       for i from 1 to total
       do (progn
            (download-image (nth (- i 1) image-urls))
            (pb:pb i total)))))

(defun main (args)
  (get-images (second args)))
