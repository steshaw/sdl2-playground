CC = gcc
CFLAGS = -Wall `pkg-config --cflags --libs SDL2_gfx`

all: bitmap hello
