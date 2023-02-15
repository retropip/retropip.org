.PHONY: deploy install build


deploy: install build

install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

build:
	nix develop -c spago test
	nix develop -c spago bundle-module
	mv index.js build/functions/

