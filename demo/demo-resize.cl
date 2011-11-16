(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :MagickWand)
    (load "MagickWand")))

(in-package :MagickWand)

;; in-file is path to file to be read.
;; new-dims is a cons for new dimensions '(x . y)
;; out-file is path to file to be written.
(defun resize-image (in-file new-dims out-file)
  (let ((wand (NewMagickWand))
	images-modified)
    (unwind-protect
	(progn
	  (when (= (MagickReadImage wand in-file)
		   MagickFalse)
	    (error "unable to read image file ~s." in-file))
	  (MagickResetIterator wand)
	  (while (/= (MagickNextImage wand) MagickFalse)
	    (MagickResizeImage wand (car new-dims) (cdr new-dims)
			       LanczosFilter 0.0d0)
	    (setf images-modified t))
	  (if* images-modified
	     then (when (= (MagickWriteImages wand out-file MagickTrue)
			   MagickFalse)
		    (error "unable to write to file ~s." out-file))
	     else (error "No images found in input file ~s." in-file))
	  images-modified)
      (DestroyMagickWand wand))))

;; resize an image to new-dims while maintaining aspect-ratio.
;; new-dims is a string of the form "NNNxNNN" where N are digits.
;; the other args are the same as above.
(defun xform-image (in-file new-dims out-file)
  (let ((wand (NewMagickWand))
	images-modified)
    (unwind-protect
	(progn
	  (when (= (MagickReadImage wand in-file)
		   MagickFalse)
	    (error "unable to read image file ~s." in-file))
	  (MagickResetIterator wand)
	  (let (xforms)
	    (while (/= (MagickNextImage wand) MagickFalse)
	      (push (MagickTransformImage wand "0x0" new-dims) xforms)
	      (setf images-modified t))
	    (if* images-modified
	       then (when (= (MagickWriteImages (first xforms) out-file MagickTrue)
			     MagickFalse)
		      (error "unable to write to file ~s." out-file))
	       else (error "No images found in input file ~s." in-file)))
	  images-modified)
      (DestroyMagickWand wand))))