#main compiler
CC := gcc

#directories
SRCDIR := src
INCDIR := include
BUILDDIR := build
BINDIR := bin
LIBDIR := lib

# The Python include and library directories
PYTHON_VERSION = 3.10
PYINCLUDE = -I/usr/include/python$(PYTHON_VERSION)
PYLIBS = -lpython3.10

# The name of the extension module
MODULE = WallControllerUtils
TARGET := $(LIBDIR)/python$(PYTHON_VERSION)/wallcontrollerutils.so
LEGACY := $(LIBDIR)/wallcontrollerutils.so


# The source files for the extension module
SOURCES = $(SRCDIR)/WallControllerUtils.c

OBJECTS := $(SOURCES:.c=.o)


# Compiler and linker flags
CFLAGS = -Wall -Werror -fPIC
LDFLAGS = -shared

#$(TARGET): $(OBJECTS)
#	@echo " Compiling $@"
#	@mkdir -p $(dir $@)
#	$(CC) -shared -o $@  $^ $(LIB)


# Build the extension module
$(TARGET): $(TARGET)
	@mkdir -p $(dir $@)
	$(CC)	$(LDFLAGS)	$(PYINCLUDE) 	$(SOURCES)	-o $@ $(CFLAGS) 	$(PYLIBS)

# Clean up the build files
clean:
	@echo "Cleaning.."
	$(RM) -r $(BUILDDIR) $(BINDIR) $(LIBDIR)

wipe:
	@echo " Cleaning just build files...";
	$(RM) -r $(BUILDDIR)
.PHONY: clean


