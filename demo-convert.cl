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
    images-modified))

    
    
