.PHONY: deploy build


deploy: nix-portable
	export NP_GIT=$(shell which git)
	./nix-portable nix develop -c make build

nix-portable:
	curl --output nix-portable -L https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable
	chmod +x nix-portable
	# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

build:
	nix develop -c spago bundle-module
	mv index.js build/functions/

