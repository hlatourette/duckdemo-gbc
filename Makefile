BUILD_DIR := build
ASSET_DIR := assets
INC_DIR   := include
SRC_DIR   := src

.PHONY: all build clean install package test

all: clean build test

build:
	mkdir -p ${BUILD_DIR} && cd build && rgbasm $(addprefix -I,../${ASSET_DIR} ../${INC_DIR} ../${SRC_DIR}) -o hello-world.o ../${SRC_DIR}/hello-world.asm && rgblink -o duckdemo.gb hello-world.o && rgbfix -v -p 0xFF duckdemo.gb

clean:
	rm -rf ${BUILD_DIR}

install:
	@echo "NOP"

package:
	@echo "NOP"

test:
	@echo "NOP"

