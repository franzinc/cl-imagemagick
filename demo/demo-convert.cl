(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :MagickWand)
    (load "MagickWand")))

(in-package :MagickWand)

;; in-file is path to file to be read.
;; new-format is a string, e.g. "tiff" "jpg" "gif"
;; out-file is path to file to be written, if not specified
;; the output file will be the input-file with new-format as
;; the extension.
(defun convert-image (in-file new-format &optional out-file)
  (let ((wand (NewMagickWand))
	images-modified)
    (unwind-protect
	(progn
	  (when (= (MagickReadImage wand in-file)
		   MagickFalse)
	    (error "unable to read image file ~s." in-file))

	  (MagickResetIterator wand)

	  (while (/= (MagickNextImage wand) MagickFalse)
	    (MagickSetImageFormat wand new-format)
	    (setf images-modified t))
	  (if* images-modified
	     then (unless out-file
		    (setf out-file (namestring
				    (merge-pathnames (make-pathname :type new-format)
						     in-file))))
		  (when (= (MagickWriteImages wand out-file MagickTrue)
			   MagickFalse)
		    (error "unable to write to file ~s." out-file))
	     else (error "No images found in input file ~s." in-file))
	  images-modified)
      (DestroyMagickWand wand))))

;; returns a blob of the converted url image
(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :aserve))

;; return a blob of the in-blob converted to new-format
(defun convert-blob-image (in-blob new-format)
  (let ((wand (NewMagickWand))
	(out-blob-len (ff:allocate-fobject :unsigned-int))
	images-modified)
    (when (= (MagickReadImageBlob wand in-blob (length in-blob))
	     MagickFalse)
      (error "unable to read image blob."))

    (MagickResetIterator wand)

    (while (/= (MagickNextImage wand) MagickFalse)
      (MagickSetImageFormat wand new-format)
      (setf images-modified t))
    (if images-modified
	(values (MagickGetImageBlob wand out-blob-len)
		(ff:fslot-value out-blob-len)))))

;; http://lisis.files.wordpress.com/2008/11/liszt.jpg
(defun convert-url (src-url new-format)
  (multiple-value-bind (resp code hdrs url)
      (net.aserve.client:do-http-request src-url :format :binary)
    (unless (= code 200)
      (error "unable to fetch resource at ~a" url))
    (let ((content-type (cdr (assoc :content-type hdrs))))
      (unless (and content-type (match-re "^image/" content-type ))
	(warn "Cannot verify resource is an image, assuming that it is and proceeding...")))
    (convert-blob-image resp new-format)))

;; writing converted image blob out to a stream....
#+sample-code
(multiple-value-bind (blob len)
    (convert-url url format-type)
  (dotimes (i len)
    (write-byte (ff:fslot-value-typed '(:array :unsigned-char) :c
				      (ff:foreign-pointer-address blob)
				      i)
		stream)))
