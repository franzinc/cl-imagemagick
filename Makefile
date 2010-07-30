# $Id: Makefile,v 1.4 2007/03/28 23:43:56 layer Exp $

on_windows := $(shell if test -d c:/; then echo yes; else echo no; fi)
on_macosx  := $(shell if test `uname -s` = "Darwin"; then echo yes; else echo no; fi)

ifeq ($(on_windows),yes)
SWIG_FLAGS := -DACL_WINDOWS
SWIG_INCLUDES := -I"C:/mikel/src/ImageMagick-6.5.2-Q16/include"
else
SWIG_FLAGS := -DACL_LINUX
SWIG_INCLUDES := -I/usr/include
endif

all: MagickWand.cl MagickCore.cl

clean:	FORCE
	rm -f MagickWand.cl MagickCore.cl
	find . -name "*.fasl" -print | xargs rm -f

MagickWand.cl: MagickWand.i
	swig -allegrocl -nocwrap $(SWIG_FLAGS) $(SWIG_INCLUDES) -isolate MagickWand.i

MagickCore.cl: MagickCore.i
	swig -allegrocl -nocwrap $(SWIG_FLAGS) $(SWIG_INCLUDES) -isolate MagickCore.i

FORCE:
