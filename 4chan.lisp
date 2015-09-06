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

(defun imagep (stp-element)
  (and (typep stp-element 'stp:element)
       (equal (stp:local-name stp-element) "a")
       (equal (stp:attribute-value stp-element "class") "fileThumb")))


(defun get-images (url)
  (setq *thread-url* url)
  (create-dir)
  (let* ((body (handler-bind ((usocket:ns-try-again-condition #'(lambda (e)
                                                                  (progn
                                                                    (format t "Cannot reach network...~%")
                                                                    (abort)))))
                 (drakma:http-request url)))
	 (document (chtml:parse body (cxml-stp:make-builder)))
         (image-urls nil)
         (fails nil))
    (stp:do-recursively (a document)
      (when (imagep a)
        (pushnew (stp:attribute-value a "href") image-urls :test 'equal)))
    (loop with total = (length image-urls)
       with pb = (make-instance 'pb:progress-bar :total total)
       for i from 1 to total
       with image-link = (nth (- i 1) image-urls)
       do (progn
            (handler-bind
                ((trivial-download:http-error #'(lambda (e) (push image-link fails))))
              (download-image image-link))
            (pb:pb-inc pb)))
    (when fails
      (format t "The following images has not being downloaded:~%")
      (dolist (image-link fails) (format t "~a~%" image-link)))))

(defun main (args)
  (get-images (second args)))
