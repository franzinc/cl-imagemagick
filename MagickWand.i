%module MagickWand

#pragma SWIG nowarn=302

%insert("lisphead")  %{
#+linux (load "/usr/lib/libWand.so")
#+mswindows (load "CORE_RL_wand_.dll")
%}

%include "MagickCore.i"

# typedef void *MagickWand, *DrawingWand, *PixelWand, *PixelIterator;



#ifdef ACL_WINDOWS
%include "wand/MagickWand.h"

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

%include "wand/MagickWand.h"

// before drawing-wand.h
%include "wand/pixel-wand.h"

// before magick-image.h
%include "wand/drawing-wand.h"

%include "wand/magick-image.h"
%include "wand/magick-wand.h"

%include "magick/api.h"
# %include "magick/convert.h"

%include "wand/pixel-iterator.h"
#endif
