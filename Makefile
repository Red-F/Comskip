####### Compiler, tools and options

CC       = cc
LEX      = flex
YACC     = yacc
ARCHFLAGS=
DEFINES  = -DDONATOR -DPROCESS_CC
CFLAGS   = -g -pipe -Wall -W -Wno-unused-parameter -Wno-unused-label -Wno-unused-result -O2 $(DEFINES) $(ARCHFLAGS)
LEXFLAGS =
YACCFLAGS= -d
INCPATH  = -I. $(INCLUDES)
LINK     = $(CC) -g
LFLAGS   = $(ARCHFLAGS)
LIBS     =
SHLIBS = -lavutil -lavformat -lavcodec -largtable2
DESTDIR = /usr/local
AR       = ar cq
RANLIB   = ranlib -s
QMAKE    = qmake
TAR      = tar -cf
GZIP     = gzip -9f
COPY     = cp -f
COPY_FILE= cp -f
COPY_DIR = cp -f -r
INSTALL_FILE= $(COPY_FILE)
INSTALL_DIR = $(COPY_DIR)
DEL_FILE = rm -f
SYMLINK  = ln -sf
DEL_DIR  = rmdir
MOVE     = mv -f
CHK_DIR_EXISTS= test -d
MKDIR    = mkdir -p

####### Output directory

OBJECTS_DIR = ./

####### Files

HEADERS = comskip.h \
		platform.h \
		vo.h
SOURCES = comskip.c \
		mpeg2dec.c \
		video_out_dx.c
OBJECTS = comskip.o \
		platform.o \
		mpeg2dec.o \
		video_out_dx.o \
		ccextratorwin/608.o \
		ccextratorwin/ccextractor.o \
		ccextratorwin/encoding.o \
		ccextratorwin/general_loop.o \
		ccextratorwin/myth.o
DIST	   = comskip.pro
QMAKE_TARGET = comskip
TARGET   = comskip

####### Platform specific

ifneq (,$(findstring Windows,$(OS)))
	PLATFORMLIBS = -L./vendor -lgdi32 -lcomdlg32
	PLATFORMINCS = -I./vendor
	SOURCES += win32_pthread.c
	OBJECTS += win32_pthread.o
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		SHLIBS += -pthread -lm
	endif
endif

ifneq (,$(DEBUG))
	CFLAGS += -ggdb -O0
endif

####### Implicit rules

first: all

.SUFFIXES: .c .o .cpp .cc .cxx .C

.c.o:
	$(CC) -c $(CFLAGS) $(PLATFORMINCS) $(INCPATH) -o $@ $<

####### Build rules

all: Makefile $(TARGET)

$(TARGET):  $(UICDECLS) $(OBJECTS) $(OBJMOC)  
	$(LINK) $(LFLAGS) -o $(TARGET) $(OBJECTS) $(OBJMOC) $(OBJCOMP) $(PLATFORMLIBS) $(LIBS) $(SHLIBS)

mocables: $(SRCMOC)
uicables: $(UICDECLS) $(UICIMPLS)

dist:
	@mkdir -p .tmp/comskip && $(COPY_FILE) --parents $(SOURCES) $(HEADERS) $(FORMS) $(DIST) .tmp/comskip/ && ( cd `dirname .tmp/comskip` && $(TAR) comskip.tar comskip && $(GZIP) comskip.tar ) && $(MOVE) `dirname .tmp/comskip`/comskip.tar.gz . && $(DEL_FILE) -r .tmp/comskip

mocclean:
uiclean:

yaccclean:
lexclean:
clean:
	-$(DEL_FILE) $(OBJECTS)
	-$(DEL_FILE) *~ core *.core


####### Sub-libraries

distclean: clean
	-$(DEL_FILE) ../../$(TARGET) $(TARGET)


FORCE:

####### Compile

comskip.o: comskip.c platform.h \
		config.h \
		comskip.h

mpeg2dec.o: mpeg2dec.c platform.h \
		config.h \
		comskip.h

platform.o: platform.c platform.h

video_out_dx.o: video_out_dx.c resource.h

####### Install

install: $(TARGET)
	$(COPY_FILE) $(TARGET) $(DESTDIR)/bin/$(TARGET)

uninstall:

