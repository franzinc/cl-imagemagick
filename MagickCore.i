%module MagickCore

#pragma SWIG nowarn=305

// va_list functions cannot be wrapped by SWIG. Ignore.
%ignore ThrowMagickExceptionList;
%ignore LogMagickEventList;
%ignore FormatImagePropertyList;
%ignore FormatMagickStringList;

%rename(ExceptionInfo)	_ExceptionInfo;
%rename(Image)		_Image;
%rename(ImageInfo)	_ImageInfo;

%ffargs(pass_structs_by_value="t") ColorizeImage;
%ffargs(pass_structs_by_value="t") TintImage;

%insert("lisphead")  %{
#+linux (load "/usr/lib/libMagick.so")
#+mswindows (load "CORE_RL_magick_.dll")
%}

typedef unsigned int size_t;
typedef int ssize_t;

typedef void * FILE;
typedef long int time_t;

%include "magick/MagickCore.h"

%include "magick/magick-type.h"
%include "magick/animate.h"
%include "magick/artifact.h"
%include "magick/client.h"
%include "magick/coder.h"
%include "magick/colorspace.h"
%include "magick/colormap.h"
%include "magick/composite.h"
%include "magick/compress.h"
%include "magick/constitute.h"
%include "magick/delegate.h"
%include "magick/display.h"
%include "magick/distort.h"
%include "magick/semaphore.h"
%include "magick/exception.h"
%include "magick/feature.h"
%include "magick/fourier.h"
%include "magick/geometry.h"

// must be ahead of random_.h
%include "magick/string_.h"
// must be ahead of gem.h
%include "magick/random_.h"

%include "magick/attribute.h"
%include "magick/compare.h"
%include "magick/decorate.h"
%include "magick/gem.h"

%include "magick/hashmap.h"

%include "magick/configure.h"

%include "magick/identify.h"
%include "magick/layer.h"
%include "magick/list.h"
%include "magick/locale_.h"
%include "magick/log.h"
%include "magick/magic.h"
%include "magick/magick.h"
%include "magick/matrix.h"
%include "magick/memory_.h"
%include "magick/module.h"
%include "magick/mime.h"
%include "magick/monitor.h"
%include "magick/option.h"
%include "magick/pixel.h"

// after pixel.h
%include "magick/histogram.h"

%include "magick/montage.h"

// after montage.h
%include "magick/morphology.h"
%include "magick/accelerate.h"
%include "magick/effect.h"

// before image.h
%include "magick/profile.h"
%include "magick/resample.h"
%include "magick/color.h"
%include "magick/timer.h"

%include "magick/cache.h"
%include "magick/cache-view.h"
%include "magick/quantum.h"
%include "magick/stream.h"

%include "magick/image.h"
%include "magick/image-view.h"

%include "magick/type.h"

// after image.h
%include "magick/draw.h"
%include "magick/paint.h"

// after montage.h and draw.h
%include "magick/annotate.h"

# %include "magick/deprecate.h"
%include "magick/enhance.h"
%include "magick/fx.h"

%include "magick/policy.h"
%include "magick/prepress.h"
%include "magick/property.h"
%include "magick/quantize.h"
%include "magick/registry.h"

%include "magick/resize.h"
%include "magick/resource_.h"
%include "magick/segment.h"
%include "magick/shear.h"
%include "magick/signature.h"
%include "magick/splay-tree.h"

// after stream.h
%include "magick/blob.h"

%include "magick/statistic.h"
// string_.h was here

%include "magick/cipher.h"

%include "magick/token.h"
%include "magick/transform.h"
%include "magick/threshold.h"
%include "magick/utility.h"
%include "magick/version.h"
%include "magick/xml-tree.h"
%include "magick/xwindow.h"
