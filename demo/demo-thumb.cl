(in-package :user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :aserve)
  (load (compile-file-if-needed #+linux86 "../linux86/MagickWand.cl"
				#+windows "../windows/MagickWand.cl"))
  (load (compile-file-if-needed "./demo-resize.cl")))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (shadowing-import 'net.aserve:start)
  (use-package '(:net.aserve :net.html.generator :MagickWand)))


(defun start-server (&optional (port 8000))
  (start :port port))

;; where actual image files are.
(defparameter *thumb-dir* "./US_State_Flags/")

;; base URL to retrieve thumbnails.
(defparameter *thumb-path* "/thumbs/")
;; tmp dir for thumbnail files
(defparameter *thumb-tmp* "./tmp/")
;; the size you want your thumbs to be.
(defparameter *thumb-dims* "100x100")
(defparameter *thumb-urls-generated* nil)

;; publish entities for all the files in *thumb-dir*
(defun publish-thumbnails ()
  (ensure-directories-exist *thumb-tmp*)
  (dolist (i (directory *thumb-dir*))
    (let ((name (file-namestring i))
	  (in-file (enough-namestring i))
	  (out-file (sys:make-temp-file-name "thumb" *thumb-tmp*))
	  (mime-type (net.aserve::lookup-mime-type i)))
      (publish :path (format nil "/thumbs/~a" name)
	       :content-type mime-type
	       :format :binary
	       :function #'(lambda (req ent)
			     (MagickWand::xform-image in-file *thumb-dims* out-file)
			     (with-http-response (req ent)
			       (with-http-body (req ent)
				 (with-open-file (thumb out-file :direction :input)
				   (let (byte)
				     (while (setf byte (read-byte thumb nil nil))
				       (write-byte byte *html-stream*))))
				 (delete-file out-file))))))))

(publish-directory 
 :prefix "/images/"
 :destination *thumb-dir*)

(publish
 :path "/"
 :content-type "text/html"
 :function
 #'(lambda (req ent)
     (with-http-response (req ent)
       (with-http-body (req ent)
	 (html (:html (:head (:title "Dynamic Thumbnail Demo - Main Page"))
		      (:body (:h1 ((:a href "/images/")
				   "Click here to view Thumbs")))))))))

(defun generate-index (req ent)
  (unless *thumb-urls-generated*
    (publish-thumbnails))
  (with-http-response (req ent)
    (with-http-body (req ent)
      (html (:html
	     (:head (:title "Dynamic Thumbnail Demo - Image Index")
		    ((:style type "text/css") "img { padding: 10px; }"))
	     (:body (dolist (i (directory *thumb-dir*))
		      (let ((name (file-namestring i)))
			(html ((:a href (format nil "/images/~a" name))
			       ((:img src (format nil "/thumbs/~a" name))))
			      )))))))))

(publish
 :path "/images/"
 :content-type "text/html"
 :function
 #'generate-index)

(publish
 :path "/images/index.htm"
 :content-type "text/html"
 :function
 #'generate-index)

(publish
 :path "/images/index.html"
 :content-type "text/html"
 :function
 #'generate-index)
