.PHONY: deploy install build


deploy: install
	./nix-portable nix develop -c spago test
	./nix-portable nix develop -c spago bundle-module
	mv index.js build/functions/

install:
	curl --output nix-portable -L https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable
	chmod +x nix-portable
	# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

build:
	nix develop -c spago test
	nix develop -c spago bundle-module
	mv index.js build/functions/

