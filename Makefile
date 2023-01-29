#main compiler
CC := gcc

#directories
SRCDIR := src
INCDIR := include
BUILDDIR := build
BINDIR := bin
LIBDIR := lib

SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -maxdepth 1 -type f \( -iname "*.$(SRCEXT)" ! -iname "*main-*.$(SRCEXT)" \) )
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS := -g # -Wall

# The Python include and library directories
PYTHON_VERSION = 3.6
PYINC = -I/usr/include/python$(PYTHON_VERSION)
INC := $(PYINC)

LIB = -lpython$(PYTHON_VERSION)

# The name of the extension module
#MODULE = WallControllerUtils
#TARGET := $(LIBDIR)/python$(PYTHON_VERSION)/wallcontrollerutils.so

# define specific binaries to create
TARGET := $(LIBDIR)/python$(PYTHON_VERSION)/wallcontrollerutils.so
LEGACY := $(LIBDIR)/wallcontrollerutils.so


##Makefile rules
all: info validate $(TARGET) $(LEGACY)


# Compiler and linker flags
#CFLAGS = -Wall -Werror -fPIC
#LDFLAGS = -shared

$(TARGET): $(OBJECTS)
	@echo " Compiling $@"
	@mkdir -p $(dir $@)
	$(CC) -shared -o $@  $^ $(LIB)

# generic: build any object file required
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<


# Build the extension module
#$(BUILDDIR): $(TARGET)
#	@mkdir -p $(dir $@)
#	$(CC)	$(LDFLAGS)	$(PYINC) 	$(SOURCES)	-o $@ $(CFLAGS) 	$(LIB)

validate:
ifeq ($(PYTHON_VERSION),)
$(info "PYTHON_VERSION variable is not set, defaulting")
else
$(info "Using PYTHON_VERSION $(PYTHON_VERSION)")
endif

info:
	@echo "PYTHON_VERSION = $(PYTHON_VERSION)"
	@echo "PYINC = $(PYINC)"

clean:
	@echo " Cleaning...";
	$(RM) -r $(BUILDDIR) $(BINDIR) $(LIBDIR)
	
wipe:
	@echo " Cleaning just build files...";
	$(RM) -r $(BUILDDIR)

.PHONY: clean


