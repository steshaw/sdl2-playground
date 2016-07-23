CC = gcc
CFLAGS = -Wall `idris --include` `pkg-config --cflags SDL2_gfx`
LDFLAGS = `pkg-config --libs SDL2_gfx`

.PHONY: all
all: generate_constants Constants.idr sdl2.o bitmap hello moves

Constants.idr: generate_constants
	./generate_constants >Constants.idr

sdl2.o: sdl2.h sdl2.c

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
