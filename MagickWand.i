%module MagickWand

#pragma SWIG nowarn=302

%insert("lisphead")  %{
#+linux (load "/usr/lib/libWand.so")
#+mswindows (load "CORE_RL_wand_.dll")
%}

%include "MagickCore.i"

%include "wand/MagickWand.h"

%include "magick/MagickCore.h"
%include "wand/animate.h"
%include "wand/compare.h"
%include "wand/composite.h"
%include "wand/conjure.h"
%include "wand/convert.h"
# %include "wand/deprecate.h"
%include "wand/display.h"
%include "wand/identify.h"
%include "wand/import.h"

%include "wand/mogrify.h"
%include "wand/montage.h"
%include "wand/pixel-wand.h"
// after pixel-wand.h
%include "wand/pixel-iterator.h"

%include "magick/api.h"
# %include "magick/convert.h"
%include "wand/drawing-wand.h"

// after drawing-wand.h
%include "wand/magick-image.h"
%include "wand/magick-property.h"

%include "wand/stream.h"
%include "wand/wand-view.h"

