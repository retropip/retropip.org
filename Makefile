.PHONY: build

build:
	mkdir -p build/functions
	npm install purescript spago esbuild
	spago test
	spago bundle-module
	mv index.js build/functions/

