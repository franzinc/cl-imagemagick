%module MagickWand

%insert("lisphead")  %{
#+linux (load "/usr/lib/libWand.so")
#+mswindows (load "CORE_RL_wand_.dll")
%}

#ifdef ACL_WINDOWS
%include "wand/MagickWand.h"

%include "magick/magick-config.h"

%include "magick/magick-type.h"
%include "magick/MagickCore.h"
%include "wand/animate.h"
%include "wand/compare.h"
%include "wand/composite.h"
%include "wand/conjure.h"
%include "wand/convert.h"
%include "wand/deprecate.h"
%include "wand/display.h"
%include "wand/drawing-wand.h"
%include "wand/identify.h"
%include "wand/import.h"
%include "wand/magick-property.h"
%include "wand/magick-image.h"
%include "wand/mogrify.h"
%include "wand/montage.h"
%include "wand/pixel-iterator.h"
%include "wand/pixel-view.h"
%include "wand/pixel-wand.h"
%include "wand/stream.h"

#else
%include "magick/ImageMagick.h"
%include "wand/magick-wand.h"

%include "magick/api.h"
%include "magick/convert.h"
%include "wand/drawing-wand.h"
%include "wand/pixel-iterator.h"
%include "wand/pixel-wand.h"
#endif
