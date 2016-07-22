CC = gcc
CFLAGS = -Wall `pkg-config --cflags SDL2_gfx`
LDFLAGS = `pkg-config --libs SDL2_gfx`

.PHONY: all
all: bitmap hello sdl2.o


Config.idr: Makefile
	@echo "%flag C \"`pkg-config --libs sdl2`\"" >Config.idr

.PHONY: rect
rect:
	idris --build rect.ipkg
