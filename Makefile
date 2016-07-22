CC = gcc
CFLAGS = -Wall `pkg-config --cflags SDL2_gfx`
LDFLAGS = `pkg-config --libs SDL2_gfx`

.PHONY: all
all: sdl2.o bitmap hello moves

Config.idr: Makefile
	@echo "%flag C \"`pkg-config --libs sdl2`\"" >Config.idr

.PHONY: bitmap
bitmap:
	idris --build bitmap.ipkg

.PHONY: moves
moves:
	idris --build moves.ipkg

.PHONY: hello
hello:
	idris --build hello.ipkg
