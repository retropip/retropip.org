.PHONY: deploy build

build:
	mkdir -p build/functions
	cp -Rvf functions/* build/functions

