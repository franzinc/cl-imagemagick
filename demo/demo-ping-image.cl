(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :MagickWand)
    (load "MagickWand")))

(in-package :MagickWand)

;; returns a wand
(defun ping-image-file (filename)
  (let ((wand (NewMagickWand)))
    (when (= (MagickPingImage wand filename)
	     MagickFalse)
      (error "unable to read image file ~s." filename))
    wand))

;; return a cons (width . height) of an image file
(defun image-dims (filename)
  (let ((wand (ping-image-file filename)))
    (prog1 (cons (MagickGetImageWidth wand) (MagickGetImageHeight wand))
      (DestroyMagickWand wand))))
